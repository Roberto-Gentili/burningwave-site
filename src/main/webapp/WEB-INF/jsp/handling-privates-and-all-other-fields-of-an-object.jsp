<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>For fields handling we are going to use&nbsp;<strong>Fields</strong>&nbsp;component; Fields component uses to cache all fields for faster access. To start we need to add the following dependency to our&nbsp;<em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Let&#8217;s take look at the code now:</p>



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
            volatile int intValue = 1;
            volatile long longValue = 2l;
            volatile float floatValue = 3f;
            volatile double doubleValue = 4.1d;
            volatile boolean booleanValue = true;
            volatile byte byteValue = (byte)5;
            volatile char charValue = 'c';
        };
        
        //Get all filtered field values of an object through memory address access
        Fields.getAllDirect(
            FieldCriteria.forEntireClassHierarchy().allThoseThatMatch(field -> {
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