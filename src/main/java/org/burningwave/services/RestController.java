/*
 * This file is derived from Burningwave Miscellaneous Services.
 *
 * Hosted at: https://github.com/burningwave/miscellaneous-services
 *
 * Modified by: Roberto Gentili
 *
 * Modifications hosted at: https://github.com/Roberto-Gentili/burningwave-site.git
 *
 * --
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Roberto Gentili
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without
 * limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
 * LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
 * EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
 * OR OTHER DEALINGS IN THE SOFTWARE.
 */
package org.burningwave.services;

import static org.burningwave.core.assembler.StaticComponentContainer.Objects;
import static org.burningwave.core.assembler.StaticComponentContainer.Synchronizer;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.atomic.AtomicLong;

import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBException;

import org.burningwave.Badge;
import org.burningwave.SimpleCache;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/miscellaneous-services/")
@CrossOrigin
@OpenAPIDefinition(
    info = @Info(
        title="Miscellaneous services",
        version = "10.0.0"
    )
)
@SuppressWarnings("unchecked")
public class RestController {
	private static final org.slf4j.Logger logger;

	private NexusConnector.Group nexusConnectorGroup;
	private GitHubConnector gitHubConnector;
	private Badge badge;
	private SimpleCache cache;
	private Map<String, Object> inMemoryCache;

    static {
    	logger = org.slf4j.LoggerFactory.getLogger(RestController.class);
    }

	public RestController (
		Badge badge,
		SimpleCache cache,
		@Nullable HerokuConnector herokuConnector,
		@Nullable NexusConnector.Group nexusConnectorGroup,
		@Nullable GitHubConnector gitHubConnector
	) throws InitializeException {
		this.cache = cache;
		this.inMemoryCache = new ConcurrentHashMap<>();
		this.badge = badge;
		this.nexusConnectorGroup = nexusConnectorGroup;
		this.gitHubConnector = gitHubConnector;
	}

	@GetMapping(path = "/nexus-connector/project-info", produces = "application/json")
	public Collection<String[]> getProjectInfo() {
		try {
			try {
				return nexusConnectorGroup.getAllProjectInfos();
			} catch (NullPointerException exc){
				if (nexusConnectorGroup == null) {
					logger.warn("The Nexus connector group is disabled");
					return null;
				}
				throw exc;
			}
		} catch (Throwable exc) {
			logger.error("Exception occurred", exc);
			return null;
		}

	}

	@GetMapping(path = "/nexus-connector/project-info/latest-release", produces = "application/json")
	public String getLatestRelease(
		@RequestParam(value = "artifactId", required = true) String artifactId
	) {
		try {
			try {
				return Optional.ofNullable(
					nexusConnectorGroup.getLatestRelease(
						artifactId
					).getValue()
				).map(value -> "\"" + value + "\"").orElseGet(() -> null);
			} catch (NullPointerException exc){
				if (nexusConnectorGroup == null) {
					logger.warn("The Nexus connector group is disabled");
					return null;
				}
				throw exc;
			}
		} catch (IllegalArgumentException exc) {
			logger.error(exc.getMessage());
			return null;
		} catch (Throwable exc) {
			logger.error("Exception occurred", exc);
			return null;
		}
	}

	@GetMapping(path = "/stats/visited-pages", produces = "application/json")
	public Long getVisitedPages(
		@RequestParam(value = "increment", required = false) boolean increment
	) {
		return getVisitedPageCounter(increment);
	}

	@GetMapping(path = "/stats/visited-pages-badge", produces = "image/svg+xml")
	public String getTotalDownloadsBadge(
		@RequestParam(value = "increment", required = false) boolean increment,
		HttpServletResponse response
	) {
		response.setHeader("Cache-Control", "no-store");
		String label = "visited pages";
		return badge.build(
			getVisitedPageCounter(increment),
			label,
			label,
			"#78e",
			93
		);
	}

	@GetMapping(path = "/stats/total-downloads", produces = "application/json")
	public Long getTotalDownloads(
		@RequestParam(value = "groupId", required = false) Set<String> groupIds,
		@RequestParam(value = "alias", required = false) Set<String> aliases,
		@RequestParam(value = "artifactId", required = false) Set<String> artifactIds,
		@RequestParam(value = "startDate", required = false) String startDate,
		@RequestParam(value = "months", required = false) String months
	) {
		return getTotalDownloadsOrNull(groupIds, aliases, artifactIds, startDate, months);
	}

	@GetMapping(path = "/stats/downloads-for-month", produces = "application/json")
	public List<Integer> getDownloadsForMonth(
		@RequestParam(value = "groupId", required = false) Set<String> groupIds,
		@RequestParam(value = "alias", required = false) Set<String> aliases,
		@RequestParam(value = "artifactId", required = false) Set<String> artifactIds,
		@RequestParam(value = "startDate", required = false) String startDate,
		@RequestParam(value = "months", required = false) String months
	) {
		try {
			try {
				return nexusConnectorGroup.getAllStats(
					groupIds,
					aliases,
					artifactIds,
					startDate != null ? new SimpleDateFormat("yyyy-MM").parse(startDate) : null,
					months != null ? Integer.valueOf(months) : null
				).getDownloadsForMonth();
			} catch (NullPointerException exc){
				if (nexusConnectorGroup == null) {
					logger.warn("The Nexus connector group is disabled");
					return null;
				}
				throw exc;
			}
		} catch (Throwable exc) {
			logger.error("Exception occurred", exc);
			return null;
		}
	}

	@GetMapping(path = "/stats/total-downloads-badge", produces = "image/svg+xml")
	public String getTotalDownloadsBadge(
		@RequestParam(value = "groupId", required = false) Set<String> groupIds,
		@RequestParam(value = "alias", required = false) Set<String> aliases,
		@RequestParam(value = "artifactId", required = false) Set<String> artifactIds,
		@RequestParam(value = "startDate", required = false) String startDate,
		@RequestParam(value = "months", required = false) String months,
		HttpServletResponse response
	) throws JAXBException, ParseException, InterruptedException, ExecutionException {
		response.setHeader("Cache-Control", "no-store");
		String label = "artifact downloads";
		return badge.build(
			getTotalDownloadsOrNull(groupIds, aliases, artifactIds, startDate, months),
			label,
			label,
			"#4c1",
			125
		);
	}

	@GetMapping(path = "/stats/star-count", produces = "application/json")
	public Integer getStarCount(
		@RequestParam(value = "repository", required = true) String[] repositories
	) {
		return getStarCountOrNull(repositories);
	}

	@GetMapping(path = "/stats/star-count-badge", produces = "image/svg+xml")
	public String getStarCountBadge(
		@RequestParam(value = "repository", required = true) String[] repositories,
		HttpServletResponse response
	) {
		response.setHeader("Cache-Control", "no-store");
		String label = "GitHub stars";
		return badge.build(
			getStarCountOrNull(repositories),
			label,
			"GitHub stars", "#EEE600", 93
		);
	}

	private Long getTotalDownloadsOrNull(Set<String> groupIds, Set<String> aliases, Set<String> artifactIds, String startDate, String months) {
		try {
			try {
				return nexusConnectorGroup.getAllStats(
					groupIds,
					aliases,
					artifactIds,
					startDate != null ? new SimpleDateFormat("yyyy-MM").parse(startDate) : null,
					months != null ? Integer.valueOf(months) : null
				).getTotalDownloads();
			} catch (NullPointerException exc){
				if (nexusConnectorGroup == null) {
					logger.warn("The Nexus connector group is disabled");
					return null;
				}
				throw exc;
			}
		} catch (IllegalArgumentException exc) {
			logger.error(exc.getMessage());
			return null;
		} catch (Throwable exc) {
			logger.error("Exception occurred", exc);
			return null;
		}
	}

	private Integer getStarCountOrNull(String[] repositories) {
		try {
			try {
				return gitHubConnector.getAllStarCount(repositories);
			} catch (NullPointerException exc){
				if (gitHubConnector == null) {
					logger.warn("The GitHub connector is disabled");
					return null;
				}
				throw exc;
			}
		} catch (Throwable exc) {
			logger.error("Exception occurred", exc);
			return null;
		}
	}



	private Long getVisitedPageCounter(boolean increment) {
		if (increment) {
			return getAndIncrementVisitedPageCounter();
		}
		return getVisitedPageCounter();
	}

	private Long getAndIncrementVisitedPageCounter() {
		return getVisitedPageCounterCachedItem().getValue().incrementAndGet();
	}

	private Long getVisitedPageCounter() {
		return getVisitedPageCounterCachedItem().getValue().get();
	}

	private SimpleCache.Item<AtomicLong> getVisitedPageCounterCachedItem() {
		String key = "burningwave.site.visitedPages";
		SimpleCache.Item<AtomicLong> output = (SimpleCache.Item<AtomicLong>)inMemoryCache.get(key);
		if (output == null) {
			output = cache.load(key);
			if (output != null) {
				inMemoryCache.put(key, output);
			}
		}
		if (output != null) {
			return output;
		}
		return Synchronizer.execute(Objects.getId(this) + key, () -> {
			SimpleCache.Item<AtomicLong> newOutput  = (SimpleCache.Item<AtomicLong>)inMemoryCache.get(key);
			if (newOutput != null) {
				return newOutput;
			}
			newOutput = new SimpleCache.Item<>();
			newOutput.setValue(new AtomicLong(0L));
    		newOutput.setTime(new Date());
			inMemoryCache.put(key, newOutput);
			return newOutput;
		});
	}

	boolean storeVisitedPageCounter() {
		String key = "burningwave.site.visitedPages";
		SimpleCache.Item<AtomicLong> output = (SimpleCache.Item<AtomicLong>)inMemoryCache.get(key);
		if (output != null) {
			cache.store(key, output);
		}
		return false;
	}

}
