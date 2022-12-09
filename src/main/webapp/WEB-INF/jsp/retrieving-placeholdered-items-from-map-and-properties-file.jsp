<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>With&nbsp;<strong>IterableObjectHelper</strong>&nbsp;component it is possible to retrieve items from map by using placeholder or not. To use this component we must add the following dependency to our&nbsp;<em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>In the following example we are going to show how to retrieve strings or objects from&nbsp;<strong><a href="/overview-and-configuration/#configuration-2">burningwave.properties</a></strong>&nbsp;file and from maps. <strong><a href="/overview-and-configuration/#configuration-2">burningwave.properties</a></strong>&nbsp;file:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">code-block-1=\
    $&#123;code-block-2&#125;\
    return (T)Date.from(zonedDateTime.toInstant());
code-block-2=\
    LocalDateTime localDateTime = (LocalDateTime)parameter[0];\
    ZonedDateTime zonedDateTime = localDateTime.atZone(ZoneId.systemDefault());</pre>



<p>Let&#8217;s take a look at the code now:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import static org.burningwave.core.assembler.StaticComponentContainer.IterableObjectHelper;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.io.PathHelper;
import org.burningwave.core.iterable.IterableObjectHelper.ResolveConfig;

@SuppressWarnings("unused")
public class ItemFromMapRetriever &#123;
    
    public void execute() throws IOException &#123;
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        PathHelper pathHelper = componentSupplier.getPathHelper();
        Properties properties = new Properties();
        properties.load(pathHelper.getResourceAsStream("burningwave.properties"));
        String code = IterableObjectHelper.resolveStringValue(
            ResolveConfig.forNamedKey("code-block-1")
            .on(properties)
        );

        Map&lt;Object, Object> map = new HashMap&lt;>();
        map.put("class-loader-01", "$&#123;class-loader-02&#125;");
        map.put("class-loader-02", "$&#123;class-loader-03&#125;");
        map.put("class-loader-03", Thread.currentThread().getContextClassLoader().getParent());
        ClassLoader parentClassLoader = IterableObjectHelper.resolveValue(
            ResolveConfig.forNamedKey("class-loader-01")
            .on(map)
        );
        
        map.clear();
        map.put("class-loaders", "$&#123;class-loader-02&#125;;$&#123;class-loader-03&#125;;");
        map.put("class-loader-02", Thread.currentThread().getContextClassLoader());
        map.put("class-loader-03", Thread.currentThread().getContextClassLoader().getParent());
        Collection&lt;ClassLoader> classLoaders = IterableObjectHelper.resolveValues(
            ResolveConfig.forNamedKey("class-loaders")
            .on(map)
            .withValuesSeparator(";")
        );
    &#125;
    
    public static void main(String[] args) throws IOException &#123;
        new ItemFromMapRetriever().execute();
    &#125;
&#125;</pre>
</div>