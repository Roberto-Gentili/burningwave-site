<div class="wp-block-column">
<a id="in-deep-look" class="anchor" href="#in-deep-look" aria-hidden="true"></a>



<h2>In depth look to<br></h2>



<hr class="wp-block-separator"/>



<p>The <strong>ClassHunter</strong> is a component that queries the classes present in the paths received in input and returns only the classes that match a chosen criterion. The searches performed by it are executed in a multithreaded context and recursively through folders and supported compressed files (zip, jar, jmod, war and ear) and even in nested compressed files and folders. This component can cache the classes found in the class paths in order to perform the next searches faster and uses a <strong>PathScannerClassLoader</strong> which is configurable through the Java coded property &#8216;<strong>class-hunter.default-path-scanner-class-loader</strong>&#8216; of the <a href="../overview-and-configuration/index.html#configuration-2">burningwave.properties</a> file. A <a href="../executing-stringified-source-code/index.html"><strong>Java coded</strong> <strong>property</strong></a><strong> </strong>is a property made of Java code that will be resolved after its compilation at runtime. The default value of the &#8216;class-hunter.default-path-scanner-class-loader&#8217; property, as you can see in the default <a href="../overview-and-configuration/index.html#configuration-2">burningwave.properties</a> file, is the following:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">class-hunter.default-path-scanner-class-loader=\
	(Supplier&lt;PathScannerClassLoader>)() -> ((ComponentSupplier)parameter[0]).getPathScannerClassLoader()</pre>



<p>&#8230; Which means that the default class loader used by the ClassHunter is the class loader supplied by the method &#8216;<strong>getPathScannerClassLoader</strong>&#8216; of <a href="../overview-and-configuration/index.html#dynamic-component-container"><strong>ComponentContainer</strong></a>. The parent class loader of this class loader can be indicated through the Java coded property &#8216;<strong>path-scanner-class-loader.parent</strong>&#8216; that has the following default value:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">path-scanner-class-loader.parent=Thread.currentThread().getContextClassLoader()</pre>



<p>&#8230;. Which means that the parent class loader is the context class loader of the current thread: this implies that if you&#8217;re scanning a path that is present in the runtime class paths, the classes used for comparison are all the loadable classes of the JVM main class loader, otherwise the classes used for comparison are all the loadable classes of the PathScannerClassLoader.</p><a id="configuration-components" class="anchor" href="#configuration-components" aria-hidden="true"></a>



<br>



<h2><a id="dynamic-component-container" class="anchor" href="#dynamic-component-container" aria-hidden="true"></a>Search configuration components<br></h2>



<hr class="wp-block-separator"/>



<p>The main search configuration object is represented by the <strong>SearchConfig</strong> class to which must be (optionally) passed the paths to be scanned and (optionally too) the query criteria represented by the <strong>ClassCriteria</strong>. If no path will be passed to SearchConfig, the scan will be executed on the paths indicated by the &#8216;<strong>paths.hunters.default-search-config.paths&#8217;</strong> property of the <a href="../overview-and-configuration/index.html#configuration-2">burningwave.properties</a> file that has the following default value:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">paths.hunters.default-search-config.paths=\
	$$&#123;paths.main-class-paths$&#125;;\
	$$&#123;paths.main-class-paths.extension$&#125;;\
	$$&#123;paths.main-class-repositories$&#125;;</pre>



<p class="has-text-align-left"> … And includes the following properties: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">paths.main-class-paths=\
	$$&#123;system.properties:java.class.path$&#125;
paths.main-class-paths.extension=\
	//$$&#123;system.properties:java.home$&#125;/lib//children:.*?\.jar;\
	//$$&#123;system.properties:java.home$&#125;/lib/ext//children:.*?\.jar;\
    //$$&#123;system.properties:java.home$&#125;/../lib//children:.*?\.jar;
paths.main-class-repositories=\
	//$$&#123;system.properties:java.home$&#125;/jmods//children:.*?\.jmod;</pre>



<p class="has-text-align-left"> &#8230; Which means that the scan will be executed through: </p>



<p class="has-text-align-left"><ul>
<li>the runtime class paths (which is indicated by the system property &#8216;java.class.path&#8217;)</li>
<li>the direct children of the &#8216;lib&#8217; folder of the jvm home that have &#8216;jar&#8217; as extension</li>
<li>the direct children of the &#8216;jmods&#8217; folder of the jvm (9 or later) home that have &#8216;jmod&#8217; as extension</li>
</ul></p>



<p class="has-text-align-left"><strong>If no ClassCriteria will be passed to SearchConfig object the search will be executed with no filter and all loadable classes of the paths will be returned</strong>. </p>



<p></p>
</div>