<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>Through <strong>PathHelper</strong> we can resolve or collect paths or retrieving resources even through supported archive files (zip, jar, jmod, ear and war). In order to accomplish the task, we initially need to add the following dependency to our <em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>So we can create a path collection by adding an entry in&nbsp;<strong><a href="/overview-and-configuration/#configuration-2">burningwave.properties</a></strong>&nbsp;file that&nbsp;<strong>starts with &#8216;paths.&#8217; prefix (this is a fundamental requirement to allow PathHelper to load the paths)</strong>, e.g.: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">paths.my-collection=c:/some folder;C:/some folder 2/ some folder 3;
paths.my-collection-2=c:/some folder 4;C:/some folder 6;</pre>



<p>  These paths could be retrieved through&nbsp;<strong>PathHelper.getPaths</strong>&nbsp;method and we can find a resource in all configured paths plus the runtime class paths (that is automatically loaded under the entry named&nbsp;<strong>&#8216;paths.main-class-paths&#8217;</strong>) by using&nbsp;<strong>PathHelper.getResource</strong>&nbsp;method, e.g.: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">ComponentSupplier componentSupplier = ComponentContainer.getInstance();
PathHelper pathHelper = componentSupplier.getPathHelper();
Collection&lt;String> paths = pathHelper.getPaths("paths.my-collection", "paths.my-collection-2"));
//With the code below all configured paths plus runtime class paths will be iterated to search
//the resource called some.jar
FileSystemItem resource = pathHelper.getResource("/../some.jar");
InputStream inputStream = resource.toInputStream();</pre>



<p>We can also use placeholder and relative paths, e.g.:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">paths.my-collection-3=C:/some folder 2/ some folder 3;
paths.my-jar=$&#123;paths.my-collection-3&#125;/../some.jar;</pre>



<p>It is also possibile to obtain references to resources of the runtime class paths by using the pre-loaded entry &#8216;paths.main-class-paths&#8217; (runtime class paths are automatically iterated for searching the path that match the entry), e.g.: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">paths.my-jar=$&#123;paths.main-class-paths&#125;/../some.jar;</pre>



<p>We can also use a&nbsp;<a href="/reaching-a-resource-of-the-file-system/"><strong>FileSystemItem</strong></a>&nbsp;listing (<strong>FSIL</strong>) expression and, for example, create a path collection of all absolute path of all classes of the runtime class paths: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">paths.all-runtime-classes=//$&#123;paths.main-class-paths&#125;//allChildren:.*?\.classes;</pre>



<p>A <strong>FSIL</strong> expression encloses in a couple of double slash an absolute path or a placeholdered path collection that will be scanned; after the second double slash we have the listing type that could refear to direct children of scanned paths (&#8216;<strong>children</strong>&#8216;) or to all nested children of scanned paths (&#8216;<strong>allChildren</strong>&#8216;); after that and colons we have the regular expression with we are going to filter the absolute paths iterated. </p>
</div>