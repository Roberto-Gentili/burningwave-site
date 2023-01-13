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
package org.burningwave;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.function.Predicate;

import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.type.AnnotatedTypeMetadata;

import io.github.toolfactory.jvm.function.template.Supplier;

public interface ShellExecutor {

	public <E extends Throwable> boolean renewSSLCertificateWithCertBot(String... arguments) throws E;

	public <E extends Throwable> boolean rebuildSSLKeyStore(String... arguments) throws E;

	public default Chain buildChain(Predicate<String[]> command, Supplier<String[]> argumentsSupplier) {
		return new Chain(command, argumentsSupplier);
	}

	public static Supplier<String[]> toArguments(String... arguments) {
		return () -> arguments;
	}

	public default String execute(String command) throws IOException {
		org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(getClass());
		logger.info("Trying to execute command {}", command);
		try (
			InputStream processInputStream = Runtime.getRuntime().exec(command).getInputStream();
			InputStreamReader processInputStreamReader = new InputStreamReader(processInputStream);
			BufferedReader processInputReader = new BufferedReader(processInputStreamReader);

		) {
		    StringBuilder output = new StringBuilder();
		    String line;
		    while ((line = processInputReader.readLine()) != null) {
		    	logger.info(line);
		    	output.append(line);
		    }
		    return output.toString();
		}
	}

	public static class Chain {
		Supplier<Boolean> command;

		public Chain(Predicate<String[]> command, Supplier<String[]> argumentsSupplier) {
			this.command = () -> command.test(argumentsSupplier.get());
		}

		public Chain ifSuccess(Predicate<String[]> command, Supplier<String[]> argumentsSupplier) {
			Supplier<Boolean> previousCommand = this.command;
			this.command = () -> {
				if (previousCommand.get()) {
					return command.test(argumentsSupplier.get());
				}
				return false;
			};
			return this;
		}

		public Chain ifFailed(Predicate<String[]> command, Supplier<String[]> argumentsSupplier) {
			Supplier<Boolean> previousCommand = this.command;
			this.command = () -> {
				if (!previousCommand.get()) {
					return command.test(argumentsSupplier.get());
				}
				return false;
			};
			return this;
		}

		public boolean execute() {
			return command.get();
		}

	}

	public static class ForLinux implements ShellExecutor {

		@Override
		public boolean renewSSLCertificateWithCertBot(
			String... arguments
		) throws IOException {
			try {
				String output = execute("sudo certbot-2 renew --cert-name " + arguments[0]);
				return output.contains("No renewals were attempted");
			} catch (Throwable exc) {
				return false;
			}
		}

		@Override
		public boolean rebuildSSLKeyStore(
			String... arguments
		) throws IOException {
			try {
				execute(
					"sudo openssl pkcs12 -export -in " + arguments[0] + " " +
					"-inkey " + arguments[1] + " -out " + arguments[2] + " "+
					"-name " + arguments[3] + " -CAfile chain.pem -caname root -password pass:" + arguments[4]
				);
				return true;
			} catch (Throwable exc) {
				return false;
			}
		}

		public static class InstantiateCondition implements Condition {

		    @Override
			public boolean matches(ConditionContext context,AnnotatedTypeMetadata metadata) {
		    	String osName = context.getEnvironment().getProperty("os.name");
		    	return osName.indexOf("nux") >= 0
	    			|| osName.indexOf("aix") >= 0;
		    }
		}

	}

}
