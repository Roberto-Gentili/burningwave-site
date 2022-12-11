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

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Set;
import java.util.TreeSet;
import java.util.function.Supplier;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.burningwave.SimpleCache;
import org.burningwave.services.NexusConnector.Group.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.lang.Nullable;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;


@org.springframework.stereotype.Controller
@RequestMapping("/")
@CrossOrigin
public class Controller {
	private static final org.slf4j.Logger logger;
	public static final String SWITCH_TO_REMOTE_APP_SUCCESSFUL_MESSAGE;

	private RestController restController;
	private GitHubConnector gitHubConnector;
	private HerokuConnector herokuConnector;
	private NexusConnector.Group nexusConnectorGroup;
	private Environment environment;
	private SimpleCache cache;
	private Supplier<String> viewStartDateSupplier;
	private Supplier<String> daysOfTheMonthFromWhichToLeaveSupplier;

    static {
    	SWITCH_TO_REMOTE_APP_SUCCESSFUL_MESSAGE = "App succesfully switched";
    	logger = org.slf4j.LoggerFactory.getLogger(Controller.class);
    }

	public Controller (
		@Nullable HerokuConnector herokuConnector,
		@Nullable NexusConnector.Group nexusConnectorGroup,
		@Nullable GitHubConnector gitHubConnector,
		RestController restController,
		Environment environment,
		SimpleCache cache
	) throws IOException {
		this.herokuConnector = herokuConnector;
		this.nexusConnectorGroup = nexusConnectorGroup;
		org.burningwave.services.NexusConnector.Group.Configuration configuration;
		if (nexusConnectorGroup != null) {
			configuration = nexusConnectorGroup.getConfiguration();
		} else {
			ObjectMapper mapper = new ObjectMapper();
			configuration = mapper.readValue(
				this.getClass().getClassLoader().getResourceAsStream("nexus-connector.group.config.default.json"),
				Configuration.class
			);
		}
		viewStartDateSupplier = () -> new SimpleDateFormat("yyyy-MM").format(configuration.getDefaultProjectConfig().getStartDate().getTime());
		daysOfTheMonthFromWhichToLeaveSupplier = () -> String.join("/", configuration.getConnector().stream().map(connConfig -> connConfig.getCache().getDayOfTheMonthFromWhichToLeave()).collect(Collectors.toCollection(TreeSet::new)).stream().map(day -> day == 1 ? "1st" : day == 2 ? "2nd" : day == 3 ? "3rd" : day + "th").collect(Collectors.toSet()));
		this.gitHubConnector = gitHubConnector;
		this.cache = cache;
		this.environment = environment;
		this.restController = restController;
	}

	@GetMapping
    public String loadIndex(
		@RequestParam(value = "message", required = false) Set<String> messages,
		HttpServletRequest request,
		Model model
	) {
		return messages != null ?
			view(request, model, "index", "index", messages.toArray(new String[messages.size()])):
			view(request, model, "index", "index");
    }

    @GetMapping(path = "/{path}/")
    public String loadContent(HttpServletRequest request, Model model, @PathVariable String path) {
    	return view(request, model, !path.equals("index") ? "common/content-template" : path, path);
    }

    @GetMapping(path = "/stats/artifact-download-chart")
    public String loadArtifactDownloadChart(HttpServletRequest request, Model model) {
    	model.addAttribute("startDate", viewStartDateSupplier.get());
    	model.addAttribute("daysOfTheMonthFromWhichToLeave", daysOfTheMonthFromWhichToLeaveSupplier.get());
    	return view(request, model,"artifact-download-chart", null);
    }

	@GetMapping(path = "/clear-cache")
	public String clearCache(
		@RequestParam(value = "Authorization", required = false) String authorizationTokenAsQueryParam,
		@RequestHeader(value = "Authorization", required = false) String authorizationTokenAsHeader,
		HttpServletRequest request, Model model
	) {
		String authorizationToken = authorizationTokenAsHeader != null ? authorizationTokenAsHeader : authorizationTokenAsQueryParam;
		Collection<String> messages = new ArrayList<>();
		String message;
		try {
			if ((environment.getProperty("application.authorization.token.type") + " " + environment.getProperty("application.authorization.token")).equals(authorizationToken)) {
				try {
					nexusConnectorGroup.clearCache();
				} catch (NullPointerException exc) {
					if (nexusConnectorGroup == null) {
						message = "The Nexus connector group is disabled";
						logger.warn(message);
						messages.add(message);
					} else {
						throw exc;
					}
				}
				try {
					gitHubConnector.clearCache();
				} catch (NullPointerException exc) {
					if (gitHubConnector == null) {
						message = "The GitHub connector is disabled";
						logger.warn(message);
						messages.add(message);
					} else {
						throw exc;
					}
				}
				restController.inMemoryCache.clear();
				cache.clear();
				if (messages.isEmpty()) {
					messages.add("Cache successfully cleaned");
				}
			} else {
				message = "Cannot clear cache: unauthorized";
				logger.warn(message);
				messages.add(message);
			}
		} catch (Throwable exc) {
			logger.error("Exception occurred", exc);
			messages.add("Exception occurred while clearing the cache: " + exc.getMessage());
		}
		return view(request, model, "index", "index", messages.toArray(new String[messages.size()]));
	}

	@GetMapping(path = "/switch-to-remote-app")
	public String switchToRemoteApp(
		@RequestParam(value = "Authorization", required = false) String authorizationTokenAsQueryParam,
		@RequestHeader(value = "Authorization", required = false) String authorizationTokenAsHeader,
		HttpServletRequest request,
		Model model
	) {
		String authorizationToken = authorizationTokenAsHeader != null ? authorizationTokenAsHeader : authorizationTokenAsQueryParam;
		String message;
		try {
			if ((environment.getProperty("application.authorization.token.type") + " " + environment.getProperty("application.authorization.token")).equals(authorizationToken)) {
				try {
					herokuConnector.switchToRemoteApp();
					message = SWITCH_TO_REMOTE_APP_SUCCESSFUL_MESSAGE;
				} catch (NullPointerException exc) {
					if (herokuConnector == null) {
						logger.warn(message = "Cannot switch app: the Heroku connector is disabled");
					} else {
						throw exc;
					}
				}
			} else {
				message = "Cannot switch app: unauthorized";
				logger.error(message);
			}
		} catch (Throwable exc) {
			logger.error("Exception occurred", exc);
			message = "Cannot switch app: " + exc.getMessage();
		}
		return view(request, model, "index", "index", message);
	}

	private String view(HttpServletRequest request, Model model, String mainLayout, String contentPath, String... message) {
		String url = request.getRequestURL().toString();
		String basePath = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath();
    	model.addAttribute("basePath", basePath);
    	if (contentPath != null) {
    		model.addAttribute("contentPath", contentPath);
    	}
    	model.addAttribute("currentPath", url);
    	if (message != null && message.length > 0) {
    		model.addAttribute("message", "[\"" + String.join("\",\"", Arrays.asList(message))  + "\"]");
    	}
    	restController.getVisitedPages(true);
        return mainLayout;
	}

}
