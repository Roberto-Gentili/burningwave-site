<div class="wp-block-column">
<p>It is possible to execute stringified source code by using the&nbsp;<strong>CodeExecutor</strong>&nbsp;in three three different ways:</p>



<ul><li><a style="color: grey;" href="#executing-code-with-BodySourceGenerator">through&nbsp;<strong>BodySourceGenerator</strong></a></li><li><a style="color: grey;" href="#executing-code-of-a-property-located-in-Burningwave-configuration-file">through a custom property in Burningwave configuration file</a></li><li><a style="color: grey;" href="#executing-code-of-a-property-located-in-a-custom-properties-file">through a custom property located in a custom Properties file</a></li></ul>



<p>To start we need to add the following dependency to our&nbsp;<em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<br><h3>
<a id="executing-code-with-BodySourceGenerator" class="anchor" href="#executing-code-with-bodysourcegenerator" aria-hidden="true"></a>Executing code with BodySourceGenerator</h3>



<hr class="wp-block-separator"/>



<p>For first way we must create a&nbsp;<strong>ExecuteConfig</strong>&nbsp;by using the within static method&nbsp;<strong>forBodySourceGenerator</strong>&nbsp;to which must be passed the&nbsp;<strong>BodySourceGenerator</strong>&nbsp;that contains the source code with the parameters used within: after that we must pass the created configuration to the <strong>execute</strong> method of CodeExecutor as shown below: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package org.burningwave.core.examples.codeexecutor;

import java.util.ArrayList;
import java.util.List;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ExecuteConfig;
import org.burningwave.core.classes.BodySourceGenerator;

public class SourceCodeExecutor &#123;
    
    public static Integer execute() &#123;
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        return componentSupplier.getCodeExecutor().execute(
            ExecuteConfig.forBodySourceGenerator(
                BodySourceGenerator.createSimple().useType(ArrayList.class, List.class)
                .addCodeLine("System.out.println(\"number to add: \" + parameter[0]);")
                .addCodeLine("List&lt;Integer> numbers = new ArrayList&lt;>();")
                .addCodeLine("numbers.add((Integer)parameter[0]);")
                .addCodeLine("System.out.println(\"number list size: \" + numbers.size());")
                .addCodeLine("System.out.println(\"number in the list: \" + numbers.get(0));")
                .addCodeLine("Integer inputNumber = (Integer)parameter[0];")
                .addCodeLine("return Integer.valueOf(inputNumber + (Integer)parameter[1]);")
            ).withParameter(Integer.valueOf(5), Integer.valueOf(3))
        );
        
    &#125;
    
    public static void main(String[] args) &#123;
        System.out.println("Total is: " + execute());
    &#125;
&#125;</pre>



<br><h3>
<a id="executing-code-of-a-property-located-in-Burningwave-configuration-file" class="anchor" href="#executing-code-of-a-property-located-in-Burningwave-configuration-file" aria-hidden="true"></a>Executing code of a property located in Burningwave configuration file</h3>



<hr class="wp-block-separator"/>



<p> To execute code from Burningwave configuration file (<strong><a href="../overview-and-configuration/index.html#configuration-2">burningwave.properties</a></strong>&nbsp;or other file that we have used to create the ComponentContainer: see <a href="../overview-and-configuration/index.html">architectural overview and configurtion</a>) we must add to it a property that contains the code and, if it is necessary to import classes, you must add them to another property named as the property that contains the code plus the suffix&nbsp;<strong>&#8216;imports&#8217;</strong>. E.g: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">code-block-1=\
	Date now= new Date();\
	return (T)now;
code-block-1.imports=java.util.Date;</pre>



<p> It is also possible to include the code of a property in another property: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">code-block-1=\
	$&#123;code-block-2&#125;\
	return (T)Date.from(zonedDateTime.toInstant());
code-block-1.imports=\
	$&#123;code-block-2.imports&#125;;\
	java.util.Date;
code-block-2=\
	LocalDateTime localDateTime = (LocalDateTime)parameter[0];\
	ZonedDateTime zonedDateTime = localDateTime.atZone(ZoneId.systemDefault());
code-block-2.imports=\
	static org.burningwave.core.assembler.StaticComponentContainer.Strings;\
	java.time.LocalDateTime;\
	java.time.ZonedDateTime;\
	java.time.ZoneId;</pre>



<p> After that, for executing the code of the property we must call the <strong>executeProperty</strong> method of CodeExecutor and passing to it the property name to be executed and the parameters used in the property code: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package org.burningwave.core.examples.codeexecutor;

import java.time.LocalDateTime;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;

public class SourceCodeExecutor &#123;
    
    public static void execute() &#123;
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        System.out.println("Time is: " +
            componentSupplier.getCodeExecutor().executeProperty("code-block-1", LocalDateTime.now())    
        );
    &#125;
    
    public static void main(String[] args) &#123;
        execute();
    &#125;
&#125;</pre>



<br><h3>
<a id="executing-code-of-a-property-located-in-a-custom-properties-file" class="anchor" href="#executing-code-of-a-property-located-in-a-custom-properties-file" aria-hidden="true"></a>Executing code of a property located in a custom properties file</h3>



<hr class="wp-block-separator"/>



<p>To execute code from a custom properties file we must add to it a property that contains the code and, if it is necessary to import classes, we must add them to another property named as the property that contains the code plus the suffix&nbsp;<strong>&#8216;imports&#8217;</strong>. E.g: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">code-block-1=\
	Date now= new Date();\
	return (T)now;
code-block-1.imports=java.util.Date;</pre>



<p>It is also possible to include the code of a property in another property: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">code-block-1=\
	$&#123;code-block-2&#125;\
	return (T)Date.from(zonedDateTime.toInstant());
code-block-1.imports=\
	$&#123;code-block-2.imports&#125;;\
	java.util.Date;
code-block-2=\
	LocalDateTime localDateTime = (LocalDateTime)parameter[0];\
	ZonedDateTime zonedDateTime = localDateTime.atZone(ZoneId.systemDefault());
code-block-2.imports=\
	static org.burningwave.core.assembler.StaticComponentContainer.Strings;\
	java.time.LocalDateTime;\
	java.time.ZonedDateTime;\
	java.time.ZoneId;</pre>



<p>After that, for executing the code of the property we must create an&nbsp;<strong>ExecuteConfig</strong>&nbsp;object and set on it:</p>



<ul><li>the path (relative or absolute) of our custom properties file</li><li>the property name to be executed</li><li>the parameters used in the property code</li></ul>



<p>Then we must call the execute method of CodeExecutor with the created ExecuteConfig object:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package org.burningwave.core.examples.codeexecutor;

import java.time.LocalDateTime;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ExecuteConfig;

public class SourceCodeExecutor &#123;
    
    public static void execute() &#123;
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        System.out.println("Time is: " +
            componentSupplier.getCodeExecutor().execute(
                ExecuteConfig.forPropertiesFile("custom-folder/code.properties")
                //Uncomment the line below if the path you have supplied is an absolute path
                //.setFilePathAsAbsolute(true)
                .setPropertyName("code-block-1")
                .withParameter(LocalDateTime.now())
            )    
        );
    &#125;
    
    public static void main(String[] args) &#123;
        execute();
    &#125;
&#125;</pre>



<p></p>
</div>