<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>To scan classes for specific annotations and collect their values by using the&nbsp;<strong><a href="/the-class-hunter-in-depth-look-to-and-configuration-guide/">ClassHunter</a></strong>, we need to initially add the following dependency to our&nbsp;<em>pom.xm</em>l:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Let&#8217;s take look at the code now:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.SearchConfig;
import org.burningwave.core.io.PathHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


public class Finder {

    public List&lt;String> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        PathHelper pathHelper = componentSupplier.getPathHelper();
        ClassHunter classHunter = componentSupplier.getClassHunter();

        SearchConfig searchConfig = SearchConfig.forPaths(
            //Here you can add all absolute path you want:
            //both folders, zip and jar will be recursively scanned.
            //For example you can add: "C:\\Users\\user\\.m2"
            //With the line below the search will be executed on runtime class paths
            pathHelper.getMainClassPaths()
        ).by(
            ClassCriteria.create().allThoseThatMatch((cls) -> {
                return
                    //Unconment one of this if you need to filter for package name
                    //cls.getPackage().getName().matches("regular expression") &amp;&amp;
                    //cls.getPackage().getName().startsWith("com") &amp;&amp;
                    //cls.getPackage().getName().equals("com.something") &amp;&amp;
                    cls.getAnnotation(Controller.class) != null &amp;&amp;
                    cls.getAnnotation(RequestMapping.class) != null;
            })
        );
        try (ClassHunter.SearchResult searchResult = classHunter.findBy(searchConfig)) {
            
            List&lt;String> pathsList = searchResult.getClasses().stream().map(cls -> 
                Arrays.asList(cls.getAnnotation(RequestMapping.class).value())
            ).flatMap(List::stream).distinct().collect(Collectors.toList());
    
            return pathsList;
        }
    }

}</pre>
</div>