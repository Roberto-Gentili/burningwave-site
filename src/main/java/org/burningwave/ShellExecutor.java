package org.burningwave;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.type.AnnotatedTypeMetadata;

public interface ShellExecutor {

	public <E extends Throwable> boolean renewSSLCertificate(String inputCert, String inputCertKey, String outputFile, String alias, String password) throws E;

	public static class ForLinux implements ShellExecutor {
		private static final org.slf4j.Logger logger;

		static {
			logger = org.slf4j.LoggerFactory.getLogger(ForLinux.class);
		}

		protected String execute(String command) throws IOException {
			logger.info("Trying to executo command {}", command);
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

		@Override
		public boolean renewSSLCertificate(String inputCert, String inputCertKey, String outputFile, String alias, String password) throws IOException {
			String output = execute("sudo certbot-2 renew");
			if (!output.contains("No renewals were attempted")) {
				execute(
					"sudo openssl pkcs12 -export -in " + inputCert + " " +
					"-inkey " + inputCertKey + " -out " + outputFile + " "+
					"-name " + alias + " -CAfile chain.pem -caname root -password pass:" + password.replace("!", "\\!").replace("$", "\\$")
				);
				return true;
			}
			return false;
		}

		public static class EnvironmentCondition implements Condition {

		    @Override
			public boolean matches(ConditionContext context,AnnotatedTypeMetadata metadata) {
		          return (context.getEnvironment().getProperty("os.name").indexOf("nux") >= 0
		                 || context.getEnvironment().getProperty("os.name").indexOf("aix") >= 0);
		     }
		}

	}

}