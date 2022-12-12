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
package org.burningwave;

import org.apache.catalina.connector.Connector;
import org.apache.coyote.http11.Http11NioProtocol;
import org.springframework.boot.web.embedded.tomcat.TomcatConnectorCustomizer;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.servlet.server.ServletWebServerFactory;
import org.springframework.core.env.Environment;

public class SSL4Tomcat {

	private SSL4Tomcat() {}

	public static class ConfigHandler implements TomcatConnectorCustomizer, SSLConfigHandler {
		private static final org.slf4j.Logger logger;
	    public static final String DEFAULT_SSL_HOSTNAME_CONFIG_NAME;

	    static {
	    	logger = org.slf4j.LoggerFactory.getLogger(ConfigHandler.class);
	    	DEFAULT_SSL_HOSTNAME_CONFIG_NAME = "_default_";
	    }

	    private Http11NioProtocol protocol;
	    private ShellExecutor shellExecutor;
	    private Environment environment;

	    public ConfigHandler(
	    	Environment environment,
    		ShellExecutor shellExecutor
		) {
	    	this.environment = environment;
	    	this.shellExecutor = shellExecutor;
		}

		@Override
		public void customize(Connector connector) {
		    Http11NioProtocol protocol = (Http11NioProtocol)connector.getProtocolHandler();
		    if (connector.getSecure()) {
		        this.protocol = protocol;
		    }
		}

	    @Override
	    public void reload() {
	    	try {
	            protocol.reloadSslHostConfig(DEFAULT_SSL_HOSTNAME_CONFIG_NAME);
	            logger.info("SSL host configuration succesfully reloaded");
	        } catch (Throwable exc) {
	            logger.warn("Cannot reload SSL host configuration", exc);
	        }
	    }

		@Override
		public void renewCertificate() {
			try {
				logger.info("Trying to renew SSL certificate");
				if (
					shellExecutor.renewSSLCertificate(
						environment.getProperty("server.ssl.key-store.orig.certificate"),
						environment.getProperty("server.ssl.key-store.orig.certificate.key"),
						environment.getProperty("server.ssl.key-store"),
						environment.getProperty("server.ssl.key-alias"),
						environment.getProperty("server.ssl.key-store-password")
					)
				) {
					logger.info("SSL certificate succesfully renewed");
					reload();
					logger.info("SSL certificate succesfully reloaded");
				} else {
					logger.info("SSL certificate not renewed");
				}
			} catch (Throwable exc) {
				if (shellExecutor != null) {
					logger.warn("Cannot renew SSL certificate", exc);
				} else {
					logger.warn("Cannot renew SSL certificate: shellExecutor is unavailable");
				}
			}

		}

	}



	public static class Configuration {
	    public static ServletWebServerFactory tomcatServletWebServerFactory(
    		Environment environment,
    		ConfigHandler sSLconfigReloader
		) {
	        Connector connector = new Connector(TomcatServletWebServerFactory.DEFAULT_PROTOCOL);
	        connector.setPort(Integer.valueOf(environment.getProperty("server.ssl.http.port")));
	        TomcatServletWebServerFactory tomcat = new TomcatServletWebServerFactory();
	        tomcat.addAdditionalTomcatConnectors(connector);
	        tomcat.addConnectorCustomizers(sSLconfigReloader);
	        return tomcat;
	    }

		public static SSLConfigHandler sSLConfigReloader(Environment environment, ShellExecutor shellExecutor) {
			return new ConfigHandler(environment, shellExecutor);
		}

	}

}
