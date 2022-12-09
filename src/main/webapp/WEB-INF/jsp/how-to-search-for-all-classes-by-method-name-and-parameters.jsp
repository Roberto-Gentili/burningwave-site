<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>To search for classes by  methods whose name begins for a given string and that takes a specific type as its first parameter by using the&nbsp;<strong><a href="/the-class-hunter-in-depth-look-to-and-configuration-guide/">ClassHunter</a></strong>, we need to initially add the following dependency to our <em>pom.xm</em>l:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>And now let&#8217;s take a look at the code</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;
import java.util.Date;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.MethodCriteria;
import org.burningwave.core.classes.SearchConfig;
import org.burningwave.core.io.PathHelper;

public class Finder {       

    public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        PathHelper pathHelper = componentSupplier.getPathHelper();
        ClassHunter classHunter = componentSupplier.getClassHunter();

        MethodCriteria methodCriteria = MethodCriteria.forEntireClassHierarchy().name(methodName -> 
            methodName.startsWith("set")
        ).and().parameterType(
            (uploadedClasses, array, idx) ->
                idx == 0 &amp;&amp; array[idx].equals(uploadedClasses.get(Date.class))
        ).skip((classes, initialClass, examinedClass) -> 
            classes.get(Object.class) == examinedClass
        );            

        SearchConfig searchConfig = SearchConfig.forPaths(
            //Here you can add all absolute path you want:
            //both folders, zip and jar will be recursively scanned.
            //For example you can add: "C:\\Users\\user\\.m2"
            //With the line below the search will be executed on runtime Classpaths
            pathHelper.getMainClassPaths()
        ).by(
            ClassCriteria.create().byMembers(
                methodCriteria
            ).useClasses(
                Date.class,
                Object.class
            )
        );

        try (ClassHunter.SearchResult searchResult = classHunter.findBy(searchConfig)) {

	        //If you need all found methods unconment this
	        //searchResult.getMembersFlatMap().values();
	
	        return searchResult.getClasses();
        }
    }

}</pre>
</div>