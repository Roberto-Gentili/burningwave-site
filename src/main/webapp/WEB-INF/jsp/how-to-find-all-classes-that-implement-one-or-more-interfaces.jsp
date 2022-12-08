<div class="wp-block-column">
<p>In order to find all classes that implement one or more interfaces by using the&nbsp;<strong><a href="/the-class-hunter-in-depth-look-to-and-configuration-guide/">ClassHunter</a></strong>, we must add the following dependency to our <em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Then let&#8217;s look for all classes that implement java.io.Closeable or java.io.Serializable interface:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.io.Closeable;
import java.io.Serializable;
import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.SearchConfig;

public class Finder {
    
    public Collection&lt;Class&lt;?>> simplifiedFind() {

        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        ClassHunter classHunter = componentSupplier.getClassHunter();
        
        //With this the search will be executed on default configured paths that are the 
        //runtime class paths plus, on java 9 and later, the jmods folder of the Java home.
        //The default configured paths are indicated in the 'paths.hunters.default-search-config.paths'
        //property of burningwave.properties file (see Architectural overview and configuration)
        try (ClassHunter.SearchResult searchResult = classHunter.findBy(
                SearchConfig.byCriteria(
                    ClassCriteria.create().allThoseThatMatch(currentScannedClass ->
                        Closeable.class.isAssignableFrom(currentScannedClass) ||
                        Serializable.class.isAssignableFrom(currentScannedClass)
                    )
                )
            )) {
            return searchResult.getClasses();
        }
    }

}</pre>



<p>It is also possible to expressly indicate the paths on which to search: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.io.Closeable;
import java.io.Serializable;
import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.SearchConfig;
import org.burningwave.core.io.PathHelper;

public class Finder {

    public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        PathHelper pathHelper = componentSupplier.getPathHelper();
        ClassHunter classHunter = componentSupplier.getClassHunter();

        SearchConfig searchConfig = SearchConfig.forPaths(
            pathHelper.getPaths(path -> path.contains("spring-core-4.3.4.RELEASE.jar"))
        ).by(
            ClassCriteria.create().byClassesThatMatch((uploadedClasses, currentScannedClass) ->
                //[1]here you recall the uploaded class by "useClasses" method.
                //In this case we're looking for all classes that implement java.io.Closeable or java.io.Serializable
                uploadedClasses.get(Closeable.class).isAssignableFrom(currentScannedClass) ||
                uploadedClasses.get(Serializable.class).isAssignableFrom(currentScannedClass)
            ).useClasses(
                //With this directive we ask the library to load one or more classes to be used for comparisons:
                //it serves to eliminate the problem that a class, loaded by different class loaders, 
                //turns out to be different for the comparison operators (eg. The isAssignableFrom method).
                //If you call this method, you must retrieve the uploaded class in all methods that support this feature like in the point[1]
                Closeable.class,
                Serializable.class
            )
        );

        try (ClassHunter.SearchResult searchResult = classHunter.findBy(searchConfig)) {
            return searchResult.getClasses();
        }
    }

}</pre>
</div>