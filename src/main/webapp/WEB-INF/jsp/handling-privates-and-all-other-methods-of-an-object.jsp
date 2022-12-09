<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>For methods handling we are going to use&nbsp;<strong>Methods</strong>&nbsp;component; Methods component uses to cache all methods and all method handles for faster access.  &nbsp;In order to accomplish the task, we initially need to add the following dependency to our <em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Let&#8217;s take a look at the code now:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import static org.burningwave.core.assembler.StaticComponentContainer.Fields;

import java.lang.reflect.Field;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.burningwave.core.classes.FieldCriteria;


@SuppressWarnings("unused")
public class FieldsHandler {
    
    public static void execute() {
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        //Fast access by memory address
        Collection&lt;Class&lt;?>> loadedClasses = Fields.getDirect(classLoader, "classes");
        //Access by Reflection
        loadedClasses = Fields.get(classLoader, "classes");
        
        //Get all field values of an object through memory address access
        Map&lt;Field, ?> values = Fields.getAllDirect(classLoader);
        //Get all field values of an object through reflection access
        values = Fields.getAll(classLoader);
        
        Object obj = new Object() {
            volatile List&lt;Object> objectValue;
            volatile int intValue;
            volatile long longValue;
            volatile float floatValue;
            volatile double doubleValue;
            volatile boolean booleanValue;
            volatile byte byteValue;
            volatile char charValue;
        };
        
        //Get all filtered field values of an object through memory address access
        Fields.getAllDirect(
            FieldCriteria.forEntireClassHierarchy().allThat(field -> {
                return field.getType().isPrimitive();
            }), 
            obj
        ).values();
    }
    
    public static void main(String[] args) {
        execute();
    }
    
}</pre>
</div>