<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import var = "latestBurningwaveCoreVersion" url = "/miscellaneous-services/nexus-connector/project-info/latest-release?artifactId=org.burningwave%3Acore"/>
<pre class="EnlighterJSRAW" data-enlighter-language="xml" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">&lt;dependency>
    &lt;groupId&gt;org.burningwave&lt;&sol;groupId&gt;
    &lt;artifactId&gt;core&lt;&sol;artifactId&gt;
    &lt;version&gt;<c:out value = "${latestBurningwaveCoreVersion}"/>&lt;&sol;version&gt;
&lt;&sol;dependency&gt;</pre>

<p>&#8230; And to use Burningwave Core as a Java module, add the following to your&nbsp;<code>module-info.java</code>:</p>

<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">requires org.burningwave.core;</pre>
