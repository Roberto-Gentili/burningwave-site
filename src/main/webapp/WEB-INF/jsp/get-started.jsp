<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p style="color:grey;text-align:justify;"><strong>Burningwave Core is an advanced and highly optimized Java library to build frameworks and it is useful for scanning class paths, generating classes at runtime, facilitating the use of reflection, scanning the filesystem, executing stringified source code, iterating collections or arrays in parallel, executing tasks in parallel and much more&#8230;</strong></p>



<p style="color:grey;text-align:justify;">Below you will find how to include the library in your projects and a simple code example. In the right side links you will find more examples of the ClassHunter and of some other components and&nbsp;<a href="https://github.com/burningwave/core/tree/master/src/test/java/org/burningwave/core">here you can find some junit test of all most used components</a>.</p>



<h3 class="has-vivid-red-color has-text-color">Get Started!</h3>



<p style="color:grey;">To use BurningWave Core in your projects you just need to name a dependency as following:</p>



<p class="has-text-color has-text-align-left has-vivid-red-color"><strong>with Apache Maven</strong>:  <br></p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>&#8230; And now, the code: let&#8217;s retrieve all classes whose package name contains &#8220;springframework&#8221; string in the runtime class paths!</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.JavaClass;
import org.burningwave.core.classes.SearchConfig;
import org.burningwave.core.io.FileSystemItem;
    
public class Finder {
    
   public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        ClassHunter classHunter = componentSupplier.getClassHunter();
        
        SearchConfig searchConfig = SearchConfig.create().setFileFilter(
            //Highly optimized scanning by filtering resources before loading from ClassLoader            
            FileSystemItem.Criteria.forAllFileThat( fileSystemItem -> {
                JavaClass javaClass = fileSystemItem.toJavaClass();
                if (javaClass == null) {
                    return false;
                }
                String packageName = javaClass.getPackageName();                       
                return packageName != null &amp;&amp; packageName.contains("springframework");
            })
        );

        try(ClassHunter.SearchResult searchResult = classHunter.findBy(searchConfig)) {
            return searchResult.getClasses();
        }
    }
    
}</pre>
</div>