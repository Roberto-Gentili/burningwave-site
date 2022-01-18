package org.burningwave.services;

import static org.burningwave.core.assembler.StaticComponentContainer.Objects;
import static org.burningwave.core.assembler.StaticComponentContainer.Synchronizer;

import java.io.Serializable;
import java.io.StringReader;
import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutionException;
import java.util.function.Supplier;
import java.util.stream.Collectors;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import org.burningwave.SimpleCache;
import org.burningwave.Throwables;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

public class NexusConnector {
	private final static org.slf4j.Logger logger;

	private RestTemplate restTemplate;
	private HttpEntity<String> entity;
	private JAXBContext jaxbContext;
	private Supplier<UriComponentsBuilder> getStatsUriComponentsBuilder;
	private Collection<Project> allProjectsInfo;
	private Map<String, GetStatsOutput> inMemoryCache;
	private long timeToLiveForInMemoryCache;
	private int dayOfTheMonthFromWhichToLeave;

	@Autowired
    private SimpleCache cache;


    static {
    	logger = org.slf4j.LoggerFactory.getLogger(NexusConnector.class);
    }

    public NexusConnector(Map<String, Object> configMap) throws JAXBException, ParseException, InstantiationException, IllegalAccessException, IllegalArgumentException, InvocationTargetException, NoSuchMethodException, SecurityException, ClassNotFoundException {
    	restTemplate = new RestTemplate();
    	HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", configMap.get("authorization.token.type") + " " + configMap.get("authorization.token"));
        entity = new HttpEntity<String>(headers);
        jaxbContext = JAXBContext.newInstance(GetStatsOutput.class);
        getStatsUriComponentsBuilder = () -> UriComponentsBuilder.newInstance().scheme("https").host((String)configMap.get("host")).path("/service/local/stats/timeline").queryParam("t", "raw");
        allProjectsInfo = retrieveProjectsInfo(configMap);
        inMemoryCache = new ConcurrentHashMap<>();
        timeToLiveForInMemoryCache = Long.parseLong((String)configMap.get("cache.ttl"));
        dayOfTheMonthFromWhichToLeave = Integer.parseInt((String)configMap.get("cache.day-of-the-month-from-which-to-leave"));
    }

	public void clearCache() {
		synchronized(inMemoryCache) {
			inMemoryCache.clear();
			logger.info("In memory cache cleaning done");
		}
	}

    public GetStatsOutput getStats(GetStatsInput input) {
		String key = getKey(input);
		GetStatsOutput output = inMemoryCache.get(key);
		if (output == null) {
			output = cache.load(key);
			if (output != null) {
				logger.info("Object with id '{}' loaded from physical cache", key);
				inMemoryCache.put(key, output);
			}
		}
		if (output != null) {
			if ((new Date().getTime() - output.getTime().getTime()) <= timeToLiveForInMemoryCache) {
    			return output;
    		}
		}
		GetStatsOutput oldOutput = output;
		return Synchronizer.execute(Objects.getId(this) + key, () -> {
    		GetStatsOutput newOutput;
			try {
				newOutput = callRemoteService(input);
			} catch (Throwable exc) {
				if (oldOutput != null) {
					return oldOutput;
				}
				return Throwables.rethrow(exc);
			}
    		Calendar newDate = new GregorianCalendar();
			newDate.setTime(new Date());
			newDate.set(Calendar.DATE, dayOfTheMonthFromWhichToLeave);
			newDate.set(Calendar.HOUR_OF_DAY, 0);
			newDate.set(Calendar.MINUTE, 0);
			newDate.set(Calendar.SECOND, 0);
			newDate.set(Calendar.MILLISECOND, 0);
    		if (oldOutput != null && oldOutput.getData().getTotal() == newOutput.getData().getTotal()) {
    			newDate.setTime(oldOutput.getTime());
    			newDate.add(Calendar.DATE, 1);
    		}
    		newOutput.setTime(newDate.getTime());
    		cache.store(key, newOutput);
			inMemoryCache.put(key, newOutput);
			return newOutput;
		});

    }

	private Collection<Project> retrieveProjectsInfo(Map<String, Object> configMap) throws ParseException {
        String projectsInfoAsString = (String)configMap.get("projects-info");
        String[] projectsInfoAsSplittedString = projectsInfoAsString.split(";");
        Calendar startDate = new GregorianCalendar();
        startDate.setTime(new SimpleDateFormat("yyyy-MM").parse(projectsInfoAsSplittedString[0]));
        Collection<Project> projectsInfo = new ArrayList<>();
        for (int i = 1; i < projectsInfoAsSplittedString.length; i++) {
        	Project project = new Project();
        	project.setStartDate(startDate);
        	String[] projectInfoAsSplittedString = projectsInfoAsSplittedString[i].split("/");
        	project.setId(projectInfoAsSplittedString[0]);
        	project.setGroupId(projectInfoAsSplittedString[1]);
        	Map<String,String> articactIds = new HashMap<>();
        	project.setArtifactIds(articactIds);
        	for (int j = 2; j < projectInfoAsSplittedString.length; j++) {
        		String[] projectNames = projectInfoAsSplittedString[j].split(":");
        		if (projectNames.length == 1) {
        			articactIds.put(projectNames[0], projectNames[0]);
        		} else if (projectNames.length == 2) {
        			articactIds.put(projectNames[0], projectNames[1]);
        		} else {
        			throw new IllegalArgumentException();
        		}
        	}
        	projectsInfo.add(project);
        }
        return projectsInfo;
	}

	private GetStatsInput toInput(Project projectInfo, String artifactId, Date startDate, Integer months) {
		GetStatsInput input = new GetStatsInput(
			projectInfo.getId(),
			projectInfo.getGroupId(),
			startDate != null? startDate : projectInfo.getStartDate().getTime()
		);
		if (artifactId != null) {
			input.setArtifactId(projectInfo.getArtifactIds().get(artifactId));
		}
		if (months != null) {
			input.setMonths(months);
		}
		return input;
	}

	private String getKey(GetStatsInput input) {
		return
			input.getClass().getName() + ";" +
			input.getProjectId() + ";" +
			input.getGroupId() + ";" +
			input.getArtifactId() + ";" +
			new SimpleDateFormat("yyyyMM").format(input.getStartDate()) + ";" +
			(input.isCustomMonths() ?
				input.getMonths():
				"defaultValue");
	}


	private GetStatsOutput callRemoteService(GetStatsInput input) throws JAXBException {
		UriComponents uriComponents =
			getStatsUriComponentsBuilder.get().queryParam("p", input.getProjectId())
			.queryParam("g", input.getGroupId())
			.queryParamIfPresent("a", Optional.ofNullable(input.getArtifactId()))
			.queryParam("from", new SimpleDateFormat("yyyyMM").format(input.getStartDate()))
			.queryParam("nom", input.getMonths())
			.build();

		ResponseEntity<String> response = restTemplate.exchange(
			uriComponents.toString(),
			HttpMethod.GET,
			entity,
			String.class
		);
		GetStatsOutput output = (GetStatsOutput) jaxbContext.createUnmarshaller().unmarshal(new StringReader(response.getBody()));
		return output;
	}

	public GetAllStatsOutput getAllStats(String artifactId, Date startDate, Integer months)
			throws ParseException, JAXBException, InterruptedException, ExecutionException {
		Collection<CompletableFuture<GetStatsOutput>> outputSuppliers = new ArrayList<>();
		for (Project projectInfo : allProjectsInfo) {
			if (artifactId != null && !projectInfo.getArtifactIds().containsKey(artifactId)) {
				continue;
			}
			outputSuppliers.add(CompletableFuture.supplyAsync(() ->
				getStats(
					toInput(projectInfo, artifactId, startDate, months)
				)
			));
		}
		GetAllStatsOutput output = merge(outputSuppliers.stream().map(outputSupplier -> outputSupplier.join()).collect(Collectors.toList()));
		return output;
	}



	private GetAllStatsOutput merge(Collection<GetStatsOutput> getStatsOutputs) {
		if (getStatsOutputs != null && getStatsOutputs.size() > 0) {
			GetAllStatsOutput output = new GetAllStatsOutput();
			for (GetStatsOutput getStatsOutput : getStatsOutputs) {
				sum(output, getStatsOutput);
			}
			return cleanUp(output);
		}
		return null;
	}

	private GetAllStatsOutput cleanUp(GetAllStatsOutput output) {
		List<Integer> downloadsForMonth = output.getDownloadsForMonth();
		for (int i = 0; i <  downloadsForMonth.size(); i++) {
			if (downloadsForMonth.get(i) == 0) {
				downloadsForMonth.set(i, null);
			} else {
				break;
			}
		}
		return output;
	}

	private void sum(GetAllStatsOutput output, GetStatsOutput getStatsOutput) {
		if (output.getTotalDownloads() == null) {
			output.setTotalDownloads(getStatsOutput.getData().getTotal());
			output.setDownloadsForMonth(new ArrayList<>(getStatsOutput.getData().getTimeline().getValues()));
			return;
		}
		output.setTotalDownloads(getStatsOutput.getData().getTotal() + output.getTotalDownloads());
		List<Integer> outputValues = output.getDownloadsForMonth();
		List<Integer> getStatsOutputValues = getStatsOutput.getData().getTimeline().getValues();
		for (int i = 0; i < outputValues.size(); i++) {
			outputValues.set(i, outputValues.get(i) + getStatsOutputValues.get(i));
		}
	}

    public static class GetStatsInput {

    	private String projectId;
    	private String groupId;
    	private String artifactId;
    	private Date startDate;
    	private Integer months;
    	private boolean customMonths;

    	private GetStatsInput(String projectId, String groupId, Date startDate) {
    		this.projectId = projectId;
    		this.groupId = groupId;
    		this.startDate = startDate;
    		Calendar today = new GregorianCalendar();
            today.setTime(new Date());
            Calendar startDateAsCalendar = new GregorianCalendar();
            startDateAsCalendar.setTime(startDate);
            this.months =
            	((today.get(Calendar.YEAR) - startDateAsCalendar.get(Calendar.YEAR))*12) +
            	today.get(Calendar.MONTH) - startDateAsCalendar.get(Calendar.MONTH);
    	}


		public String getProjectId() {
			return projectId;
		}

		public String getGroupId() {
			return groupId;
		}

		public String getArtifactId() {
			return artifactId;
		}
		public GetStatsInput setArtifactId(String artifactId) {
			this.artifactId = artifactId;
			return this;
		}
		public Date getStartDate() {
			return startDate;
		}
		public GetStatsInput setStartDate(Date startDate) {
			this.startDate = startDate;
			return this;
		}
		public Integer getMonths() {
			return months;
		}
		public GetStatsInput setMonths(Integer months) {
			this.months = months;
			customMonths = true;
			return this;
		}
		boolean isCustomMonths() {
			return customMonths;
		}
    }

    public static class GetAllStatsOutput implements Serializable {

		private static final long serialVersionUID = 287571224336835644L;

		private Long totalDownloads;
    	private List<Integer> downloadsForMonth;

		public Long getTotalDownloads() {
			return totalDownloads;
		}

		void setTotalDownloads(Long total) {
			this.totalDownloads = total;
		}

		public List<Integer> getDownloadsForMonth() {
			return downloadsForMonth;
		}

		void setDownloadsForMonth(List<Integer> values) {
			this.downloadsForMonth = values;
		}

    }

	@XmlRootElement(name = "statsTimelineResp")
	public static class GetStatsOutput implements Serializable {
		private Date time;
		private Data data;

	    @XmlTransient
		public Date getTime() {
			return time;
		}

		public void setTime(Date time) {
			this.time = time;
		}

		@XmlElement
		public Data getData() {
			return data;
		}

		public void setData(Data data) {
			this.data = data;
		}

		private static final long serialVersionUID = 3642117423686944572L;

		public static class Data implements Serializable {

			private static final long serialVersionUID = -5272099947960951863L;


			private String projectId;
			private String groupId;
			private String artifactId;
			private String type;
			private long total;
			private Timeline timeline;

			@XmlElement
			public String getProjectId() {
				return projectId;
			}
			public void setProjectId(String projectId) {
				this.projectId = projectId;
			}

			@XmlElement
			public String getGroupId() {
				return groupId;
			}
			public void setGroupId(String groupId) {
				this.groupId = groupId;
			}

			@XmlElement
			public String getArtifactId() {
				return artifactId;
			}
			public void setArtifactId(String artifactId) {
				this.artifactId = artifactId;
			}

			@XmlElement
			public String getType() {
				return type;
			}
			public void setType(String type) {
				this.type = type;
			}

			@XmlElement
			public long getTotal() {
				return total;
			}
			public void setTotal(long total) {
				this.total = total;
			}


			@XmlElement
			public Timeline getTimeline() {
				return timeline;
			}
			public void setTimeline(Timeline timeline) {
				this.timeline = timeline;
			}


			public static class Timeline implements Serializable {

				private static final long serialVersionUID = 2507704512441988141L;

				private List<Integer> values;

				@XmlElement(name = "int")
				public List<Integer> getValues() {
					return values;
				}

				public void setValues(List<Integer> values) {
					this.values = values;
				}

			}
		}

	}

	private static class Project {
		private Calendar startDate;
		private String id;
		private String groupId;
		private Map<String, String> artifactIds;


		public Calendar getStartDate() {
			return startDate;
		}
		public void setStartDate(Calendar startDate) {
			this.startDate = startDate;
		}
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getGroupId() {
			return groupId;
		}
		public void setGroupId(String groupId) {
			this.groupId = groupId;
		}
		public Map<String, String> getArtifactIds() {
			return artifactIds;
		}
		public void setArtifactIds(Map<String, String> artifactIds) {
			this.artifactIds = artifactIds;
		}


	}

}
