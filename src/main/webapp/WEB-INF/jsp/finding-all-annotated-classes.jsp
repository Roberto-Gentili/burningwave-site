<div class="wp-block-column">
<p>In order to find all annotated classes by using the&nbsp;<strong><a href="../in-depth-look-to-and-configuration-guide/index.html">ClassHunter</a></strong>,  we must add the following dependency to our <em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Now we are able to find all annotated classes:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.ConstructorCriteria;
import org.burningwave.core.classes.FieldCriteria;
import org.burningwave.core.classes.MethodCriteria;
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
            //With the line below the search will be executed on runtime Classpaths
            pathHelper.getMainClassPaths()
        ).by(
            ClassCriteria.create().allThoseThatMatch((cls) -> {
                return cls.getAnnotations() != null &amp;&amp; cls.getAnnotations().length > 0;
            }).or().byMembers(
                MethodCriteria.withoutConsideringParentClasses().allThoseThatMatch((method) -> {
                    return method.getAnnotations() != null &amp;&amp; method.getAnnotations().length > 0;
                })
            ).or().byMembers(
                FieldCriteria.withoutConsideringParentClasses().allThoseThatMatch((field) -> {
                    return field.getAnnotations() != null &amp;&amp; field.getAnnotations().length > 0;
                })
            ).or().byMembers(
                ConstructorCriteria.withoutConsideringParentClasses().allThoseThatMatch((ctor) -> {
                    return ctor.getAnnotations() != null &amp;&amp; ctor.getAnnotations().length > 0;
                })
            )
        );

        try (ClassHunter.SearchResult searchResult = classHunter.findBy(searchConfig)) {
    
            //If you need all annotaded methods unconment this
            //searchResult.getMembersFlatMap().values();
    
            return searchResult.getClasses();
        }
    }
}</pre>
</div>