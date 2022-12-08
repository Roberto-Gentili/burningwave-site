<div class="wp-block-column">
<p> In order to find all classes that extend a base class by using the&nbsp;<strong><a href="/the-class-hunter-in-depth-look-to-and-configuration-guide/">ClassHunter</a></strong>,  we must add to our <em>pom.xml</em> the following dependency:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Let&#8217;s take a look at the code:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.ClassHunter.SearchResult;
import org.burningwave.core.classes.SearchConfig;
import org.burningwave.core.io.PathHelper;

public class Finder {

    public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        PathHelper pathHelper = componentSupplier.getPathHelper();
        ClassHunter classHunter = componentSupplier.getClassHunter();

        try (ClassHunter.SearchResult searchResult = classHunter.findBy(
                SearchConfig.forPaths(
                	pathHelper.getAllMainClassPaths()
                ).by(
                    ClassCriteria.create().allThoseThatMatch((currentScannedClass) ->
                        currentScannedClass.getModule().getName() != null &amp;&amp; 
                        currentScannedClass.getModule().getName().equals("jdk.xml.dom")
                    )
                )
            )
        ) {
            return searchResult.getClasses();
        }
    }
}</pre>
</div>