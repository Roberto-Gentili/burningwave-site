/*
 * This file is part of Burningwave Site.
 *
 * Author: Roberto Gentili
 *
 * Hosted at: https://github.com/Roberto-Gentili/burningwave-site.git
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
import java.util.Arrays;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

public abstract class WordPressSiteAdapter {
	protected final org.slf4j.Logger logger;

	protected WordPressSiteAdapter () {
		this.logger = org.slf4j.LoggerFactory.getLogger(getClass());
	}


	@org.springframework.web.bind.annotation.RestController
	@RequestMapping("/")
	@CrossOrigin
	public static class RestController extends WordPressSiteAdapter {

		protected org.burningwave.services.RestController restController;

		public RestController(org.burningwave.services.RestController restController) {
			super();
			this.restController = restController;
		}

		@GetMapping(path = "/generators/generate-visited-pages-badge.php", produces = "image/svg+xml")
	    public String getVisitedPagesBadge(
			@RequestParam(value = "withoutIncrement", required = false) Boolean withoutIncrement,
			@RequestParam(value = "hidden", required = false) Boolean hidden,
			HttpServletResponse response
		) {
	    	return restController.getVisitedPagesBadge(withoutIncrement == null || !withoutIncrement, hidden, response);
	    }

		@GetMapping(path = "/generators/generate-burningwave-artifact-downloads-badge.php", produces = "image/svg+xml")
	    public String getTotalDownloadsBadge(
			@RequestParam(value = "artifactId", required = false) Set<String> artifactIds,
			@RequestParam(value = "startDate", required = false) String startDate,
			@RequestParam(value = "months", required = false) String months,
			HttpServletResponse response
		) {
	    	return restController.getTotalDownloadsBadge(
    			null,
    			artifactIds,
    			null,
    			startDate,
    			months,
    			response
			);
	    }

		@GetMapping(path = "/generators/generate-github-stars-badge.php", produces = "image/svg+xml")
	    public String getTotalStarCountBadge(HttpServletResponse response) {
	    	return restController.getStarCountBadge(
    			new LinkedHashSet<>(
					Arrays.asList(
						"burningwave:core",
						"burningwave:jvm-driver",
						"burningwave:tools",
						"burningwave:reflection",
						"burningwave:miscellaneous-services",
						"burningwave:graph"
					)
				),
    			response
			);
	    }

	}

	@org.springframework.stereotype.Controller
	@RequestMapping("/")
	@CrossOrigin
	public static class Controller extends WordPressSiteAdapter {
		protected org.burningwave.services.Controller controller;

		public Controller(org.burningwave.services.Controller controller) {
			super();
			this.controller = controller;
		}

		@GetMapping(path = "/artifact-downloads/")
	    public void loadContent(
    		@RequestParam(value = "artifactId", required = false) Set<String> artifactIds,
    		@RequestParam(value = "startDate", required = false) String startDate,
    		@RequestParam(value = "months", required = false) String months,
    		HttpServletResponse response
		) throws IOException {
			Collection<String> queryStringItems = new LinkedHashSet<>();
			if (artifactIds != null && !artifactIds.isEmpty()) {
				queryStringItems.add(
					String.join("&",
						artifactIds.stream().map(artifactId -> "alias=" + artifactId).collect(Collectors.toSet())
					)
				);
			}
			if (startDate != null) {
				queryStringItems.add("startDate=" + startDate);
			}
			if (months != null) {
				queryStringItems.add("months=" + months);
			}
			response.sendRedirect("/stats/artifact-download-chart?" + String.join("&", queryStringItems));
	    }

	}



}
