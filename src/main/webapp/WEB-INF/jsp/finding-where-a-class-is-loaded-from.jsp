<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>In order to find where a class is loaded from by using the&nbsp;<strong>ClassPathHunter</strong>,&nbsp;we need to initially add the following dependency to our <em>pom.xm</em>l:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>And now let&#8217;s take a look at the code:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">
import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassPathHunter;
import org.burningwave.core.classes.SearchConfig;
import org.burningwave.core.io.FileSystemItem;
import org.burningwave.core.io.PathHelper;
    
public class Finder {
    
   public Collection&lt;FileSystemItem> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        PathHelper pathHelper = componentSupplier.getPathHelper();
        ClassPathHunter classPathHunter = componentSupplier.getClassPathHunter();
        
        SearchConfig searchConfig = SearchConfig.forPaths(
            //Here you can add all absolute path you want:
            //both folders, zip and jar will be recursively scanned.
            //For example you can add: "C:\\Users\\user\\.m2"
            //With the line below the search will be executed on runtime class paths
            pathHelper.getMainClassPaths()
        ).addFileFilter(
            FileSystemItem.Criteria.forAllFileThat(fileSystemItem -> {
	            JavaClass javaClass = fileSystemItem.toJavaClass();
        	    return javaClass != null &amp;&amp; javaClass.getName().equals(Finder.class.getName());
            })
        );

        try(ClassPathHunter.SearchResult searchResult = classPathHunter.findBy(searchConfig)) {
            return searchResult.getClassPaths();
        }
    }
    
}</pre>
</div>