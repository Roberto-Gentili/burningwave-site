<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>In order to find all classes that extend a base class  by using the&nbsp;<strong><a href="/the-class-hunter-in-depth-look-to-and-configuration-guide/">ClassHunter</a></strong>,  we must add to our <em>pom.xml</em> the following dependency:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>So let&#8217;s look for all classes that extend java.util.AbstractList: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.AbstractList;
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
            //Here you can add all absolute path you want:
            //both folders, zip and jar will be recursively scanned.
            //For example you can add: "C:\\Users\\user\\.m2"
            //With the row below the search will be executed on runtime Classpaths
            //(see https://github.com/burningwave/core/wiki/In-depth-look-to-ClassHunter-and-configuration-guide)
            pathHelper.getMainClassPaths()
        ).by(
            ClassCriteria.create().byClassesThatMatch((uploadedClasses, currentScannedClass) ->
                //[1]here you recall the uploaded class by "useClasses" method. In this case we find all class who extends java.util.AbstractList
                uploadedClasses.get(AbstractList.class).isAssignableFrom(currentScannedClass)
            ).useClasses(
                //With this directive we ask the library to load one or more classes to be used for comparisons:
                //it serves to eliminate the problem that a class, loaded by different class loaders, 
                //turns out to be different for the comparison operators (eg. The isAssignableFrom method).
                //If you call this method, you must retrieve the uploaded class in all methods that support this feature like in the point[1]
                AbstractList.class
            )
        );
        
        try (ClassHunter.SearchResult searchResult = classHunter.findBy(searchConfig)) {
            return searchResult.getClasses();
        }        
    }

}
</pre>
</div>