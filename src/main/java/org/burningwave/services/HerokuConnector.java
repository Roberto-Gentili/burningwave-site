/*
 * This file is part of Burningwave Miscellaneous Services.
 *
 * Author: Roberto Gentili
 *
 * Hosted at: https://github.com/burningwave/miscellaneous-services
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

import java.util.Map;
import java.util.function.Function;
import java.util.function.Supplier;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

public class HerokuConnector {
	private final static org.slf4j.Logger logger;

	private HttpHeaders appHttpHeaders;
	private HttpHeaders remoteAppHttpHeaders;
	private Function<String, String> uriSupplier;

	@Autowired
	private RestTemplate restTemplate;

	@Autowired
	private Application application;

    static {
    	logger = org.slf4j.LoggerFactory.getLogger(HerokuConnector.class);
    }

    public HerokuConnector(Map<String, String> configuration) {
    	appHttpHeaders = new HttpHeaders();
    	appHttpHeaders.add("Authorization", "Bearer " + configuration.get("authorization.token"));
    	appHttpHeaders.add("Accept", "application/vnd.heroku+json; version=3");
    	appHttpHeaders.add("Content-Type", "application/json");

    	remoteAppHttpHeaders = new HttpHeaders();
    	remoteAppHttpHeaders.add("Authorization", "Bearer " + configuration.get("remote.authorization.token") );
    	remoteAppHttpHeaders.add("Accept", "application/vnd.heroku+json; version=3");
    	remoteAppHttpHeaders.add("Content-Type", "application/json");

    	uriSupplier = relativePath -> UriComponentsBuilder.newInstance()
	    	.scheme("https")
	    	.host("api.heroku.com")
	    	.pathSegment("apps", relativePath).build().toString();
    }

    public void switchToRemoteApp() {
    	String schemeAndHostName = application.schemeAndHostName;
    	while (application.schemeAndHostName == null) {
    		synchronized(application) {
    			try {
					application.wait();
				} catch (InterruptedException exc) {
					logger.error("Exception occurred", exc);
				}
    		}
    	}
    	String appName = schemeAndHostName.substring(schemeAndHostName.indexOf("//") + 2, schemeAndHostName.indexOf("."));
        JSONObject request = new JSONObject();

        tryUntilExecuted(
        	() -> {
		        request.put("maintenance", Boolean.TRUE);
		        request.put("name", appName + "-temp-off");
		        return restTemplate.exchange(
		    		uriSupplier.apply(appName),
					HttpMethod.PATCH,
					new HttpEntity<String>(request.toString(), appHttpHeaders),
					Map.class
				);
	        }, 1
        );

        tryUntilExecuted(
	        () -> {
	        	request.put("maintenance", Boolean.FALSE);
		    	request.put("name", appName);
		    	return restTemplate.exchange(
		    		uriSupplier.apply(appName + "-off"),
					HttpMethod.PATCH,
					new HttpEntity<String>(request.toString(), remoteAppHttpHeaders),
					Map.class
				);
		   }, 2
        );

        tryUntilExecuted(
	        () -> {
	        	request.put("maintenance", Boolean.TRUE);
		    	request.put("name", appName + "-off");
		    	return restTemplate.exchange(
		    		uriSupplier.apply(appName + "-temp-off"),
					HttpMethod.PATCH,
					new HttpEntity<String>(request.toString(), appHttpHeaders),
					Map.class
				);
		    }, 3
    	);
    }

    private void tryUntilExecuted(Supplier<ResponseEntity<?>> responseEntitySupplier, int stepCount) {
    	while (true) {
    		try {
    			responseEntitySupplier.get();
    			logger.info("Step " + stepCount + " of switch to the remote app was successful");
    			break;
    		} catch (Throwable exc) {
    			logger.error("Exception occurred while executing step " + stepCount + " of switch to the remote app", exc);
    		}
    	}

    }

}
