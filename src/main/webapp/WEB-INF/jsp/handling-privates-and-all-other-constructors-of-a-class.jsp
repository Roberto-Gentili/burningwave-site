<div class="wp-block-column">
<p>For constructors handling we are going to use&nbsp;<strong>Constructors</strong>&nbsp;component. Constructors component uses to cache all constructors and all method handles for faster access. To start we need to add the following dependency to our&nbsp;<em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Let&#8217;s take a look at the code now:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import static org.burningwave.core.assembler.StaticComponentContainer.Constructors;

import org.burningwave.core.classes.MemoryClassLoader;

public class ConstructorsHandler {
    
    public static void execute() {
        //Invoking constructor by using reflection
        MemoryClassLoader classLoader = Constructors.newInstanceOf(MemoryClassLoader.class, Thread.currentThread().getContextClassLoader());
        
        //Invoking constructor with a null parameter value by using MethodHandle
        classLoader = Constructors.newInstanceDirectOf(MemoryClassLoader.class, null);
    }
    
    public static void main(String[] args) {
        execute();
    }
    
}</pre>
</div>