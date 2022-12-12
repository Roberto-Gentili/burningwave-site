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
package org.burningwave;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Random;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Supplier;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

public class Utility {
	private static final Random randomizer;
	private static final org.slf4j.Logger logger;

	static {
		randomizer = new Random();
		logger = org.slf4j.LoggerFactory.getLogger(Utility.class);
	}

	public byte[] serialize(Serializable object) throws IOException {
		try (ByteArrayOutputStream bAOS = new ByteArrayOutputStream(); ObjectOutputStream oOS = new ObjectOutputStream(bAOS);) {
	        oOS.writeObject(object);
	        return bAOS.toByteArray();
		}
	}

	public String toBase64(Serializable object) throws IOException {
		return Base64.getEncoder().encodeToString(serialize(object));
	}

	@SuppressWarnings("unchecked")
	public <T extends Serializable> T deserialize(byte[] objectAsBytes) throws IOException, ClassNotFoundException {
		ByteArrayInputStream bAIS = new ByteArrayInputStream(objectAsBytes);
        ObjectInputStream oIS = new ObjectInputStream(bAIS);
        Object o  = oIS.readObject();
        oIS.close();
        bAIS.close();
        return (T) o;
	}

	public <T extends Serializable> T fromBase64(String objectAsString) throws IOException, ClassNotFoundException {
		return deserialize(Base64.getDecoder().decode(objectAsString));
	}

	public boolean delete(File file) {
		return delete(file, true);
	}

	public boolean delete(File file, boolean deleteItSelf) {
		if (file.isDirectory()) {
		    File[] files = file.listFiles();
		    if(files != null) { //some JVMs return null for empty dirs
		        for(File fsItem: files) {
		            delete(fsItem, true);
		        }
		    }
		}
		if (deleteItSelf && !file.delete()) {
    		file.deleteOnExit();
    		return false;
    	}
		return true;
	}


	public Calendar newCalendarAtTheStartOfTheMonth() {
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(new Date());
		return setCalendarAtTheStartOfTheMonth(calendar);
	}

	public Calendar setCalendarAtTheStartOfTheMonth(Calendar calendar) {
		calendar.set(Calendar.DATE, 0);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		return calendar;
	}

	public String toPlaceHolder(String variable) {
		return "${" + variable + "}";
	}

	public String randomHex() {
		return String.format("%06x", randomizer.nextInt(0xffffff + 1));
	}

	public <T> void setIfNotNull(Consumer<T> target, Supplier<T> source) {
		T value = source.get();
		if (value != null) {
			target.accept(value);
		}
	}

	public X509Certificate getX509Certificate(
		InputStream certificateIS,
		String aliasToFind,
		String password
	) throws KeyStoreException, NoSuchAlgorithmException, CertificateException, IOException {
		KeyStore keystore = KeyStore.getInstance(KeyStore.getDefaultType());
        keystore.load(certificateIS, password.toCharArray());
        return (X509Certificate)keystore.getCertificate(aliasToFind);
	}

	public Resource[] getResources(Function<String, Resource> resourceSupplier, String... resourceRawPaths) throws IOException {
		List<Resource> resourceList = new ArrayList<>();
		PathMatchingResourcePatternResolver pathMatchingResourcePatternResolver = new PathMatchingResourcePatternResolver();
		for (int i = 0; i < resourceRawPaths.length; i++) {
			if (resourceRawPaths[i] == null) {
				logger.warn("Resource at index {} is null", i);
				continue;
			}
			for (String resourcePath : resourceRawPaths[i].split(",")) {
				if (pathMatchingResourcePatternResolver.getPathMatcher().isPattern(resourcePath)) {
					resourceList.addAll(
						Arrays.asList(
							pathMatchingResourcePatternResolver.getResources(resourcePath)
						)
					);
				} else {
					Resource resource = resourceSupplier.apply(resourcePath);
					if (resource.exists()) {
						resourceList.add(resource);
					} else {
						logger.warn("Resource {} not found", resourcePath);
					}
				}
			}
		}
		return resourceList.toArray(new Resource[resourceList.size()]);
	}

	public String adjustPathForSpring(String path) {
		if (path.startsWith("classpath:") || path.startsWith("file:")) {
			return path;
		} else if (path.startsWith("/")) {
			return "file:" + path;
		} else {
			return "classpath:" + path;
		}
	}

}