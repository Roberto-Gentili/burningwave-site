package org.burningwave;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.type.AnnotatedTypeMetadata;

public interface ShellExecutor {

	public <E extends Throwable> void renewSSLCertificate(String inputCert, String inputCertKey, String outputFile, String alias, String password) throws E;

	public static class ForLinux implements ShellExecutor {
		private static final org.slf4j.Logger logger;

		static {
			logger = org.slf4j.LoggerFactory.getLogger(ForLinux.class);
		}

		protected void execute(String command) throws IOException {
			logger.info("Trying to executo command {}", command);
			Process pb = Runtime.getRuntime().exec(command);
		    String line;
		    BufferedReader input = new BufferedReader(new InputStreamReader(pb.getInputStream()));
		    while ((line = input.readLine()) != null) {
		    	logger.info(line);
		    }
		    input.close();
		}

		@Override
		public void renewSSLCertificate(String inputCert, String inputCertKey, String outputFile, String alias, String password) throws IOException {
			execute("sudo certbot-2 renew");
			execute(
				"sudo openssl pkcs12 -export -in " + inputCert + " " +
				"-inkey " + inputCertKey + " -out " + outputFile + " "+
				"-name " + alias + " -CAfile chain.pem -caname root -password pass:" + password.replace("!", "\\!").replace("$", "\\$")
			);
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
