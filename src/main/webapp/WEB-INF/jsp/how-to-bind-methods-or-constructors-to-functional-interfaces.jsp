<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>To bind methods or constructors to functional interfaces we are going to use the&nbsp;<strong>FunctionalInterfaceFactory</strong>. FunctionalInterfaceFactory component uses to cache all generated functional interfaces for faster access. The complete source code of the following examples is available&nbsp;<a href="https://github.com/burningwave/core/tree/master/src/test/java/org/burningwave/core/examples/functionalinterfacefactory"><strong>here</strong></a>. </p>



<p>To start we need to add the following dependency to our&nbsp;<em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<br><h3>
<a id="constructors-binding" class="anchor" href="#constructors-binding" aria-hidden="true"></a>Constructors binding</h3>



<hr class="wp-block-separator"/>



<p>To bind constructors to functional interfaces we will use the following constructors: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">private Service(String id, String name, String... items) {                                                                          
    this.id = id;                                                                                                                   
    this.name = name;                                                                                                               
    this.items = items;                                                                                                             
    logInfo("\nMultiparameter constructor:\n\tid: {}\n\tname: {} \n\titems: {}", this.id, this.name, String.join(", ", this.items));
}                                                                                                                                   
                                                                                                                                    
private Service(String name, String... items) {                                                                                     
    this.id = UUID.randomUUID().toString();                                                                                         
    this.name = name;                                                                                                               
    this.items = items;                                                                                                             
    logInfo("\nMultiparameter constructor:\n\tid: {}\n\tname: {} \n\titems: {}", this.id, this.name, String.join(", ", this.items));
}                                                                                                                                   
                                                                                                                                    
private Service(String... name) {                                                                                                   
    this.id = UUID.randomUUID().toString();                                                                                         
    this.name = name[0];                                                                                                            
    this.items = null;                                                                                                              
    logInfo("\nSingle parameter varargs constructor:\n\tname: {}", this.name);                                                      
}                                                                                                                                   
                                                                                                                                    
private Service(String name) {                                                                                                      
    this.id = UUID.randomUUID().toString();                                                                                         
    this.name = name;                                                                                                               
    this.items = null;                                                                                                              
    logInfo("\nSingle parameter constructor:\n\tname: {}", this.name);                                                              
}                                                                                                                                   
                                                                                                                                    
private Service() {                                                                                                                 
    this.id = UUID.randomUUID().toString();                                                                                         
    this.name = "no name";                                                                                                          
    this.items = null;                                                                                                              
    logInfo("\nNo parameter constructor:\n\tname: {}", this.name);                                                                  
}    </pre>



<p>&#8230; And now let&#8217;s see the code needed to bind and call the generated functional interfaces: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">ComponentContainer componentContainer = ComponentContainer.getInstance();                                                            
FunctionalInterfaceFactory fIF = componentContainer.getFunctionalInterfaceFactory();                                                 
                                                                                                                                     
MultiParamsFunction&lt;Service> serviceInstantiatorZero = fIF.getOrCreate(Service.class, String.class, String.class, String[].class);   
Service serviceZero = serviceInstantiatorZero.apply(UUID.randomUUID().toString(), "Service Zero", new String[] {"item 1", "item 2"});
                                                                                                                                     
BiFunction&lt;String, String[], Service> serviceInstantiatorOne = fIF.getOrCreate(Service.class, String.class, String[].class);         
Service serviceOne = serviceInstantiatorOne.apply("Service One", new String[] {"item 1", "item 2"});                                 
                                                                                                                                     
Function&lt;String[], Service> serviceInstantiatorTwo = fIF.getOrCreate(Service.class, String[].class);                                 
Service serviceTwo = serviceInstantiatorTwo.apply(new String[] {"Service Two"});                                                     
                                                                                                                                     
Function&lt;String, Service> serviceInstantiatorThree = fIF.getOrCreate(Service.class, String.class);                                   
Service serviceThree = serviceInstantiatorThree.apply("Service Three");                                                              
                                                                                                                                     
Supplier&lt;Service> serviceInstantiatorFour = fIF.getOrCreate(Service.class);                                                          
Service serviceFour = serviceInstantiatorFour.get();</pre>



<br><h3>
<a id="methods-binding" class="anchor" href="#methods-binding" aria-hidden="true"></a>Methods binding</h3>



<hr class="wp-block-separator"/>



<p> To bind methods to functional interfaces we will use the following methods: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">private Long reset(String id, String name, String... items) {                                                                  
    this.id = id;                                                                                                              
    this.name = name;                                                                                                          
    this.items = items;                                                                                                        
    logInfo("\nMultiparameter method:\n\tid: {}\n\tname: {} \n\titems: {}", this.id, this.name, String.join(", ", this.items));
    return System.currentTimeMillis();                                                                                         
}                                                                                                                              
                                                                                                                               
private Long reset(String name, String... items) {                                                                             
    this.id = UUID.randomUUID().toString();                                                                                    
    this.name = name;                                                                                                          
    this.items = items;                                                                                                        
    logInfo("\nMultiparameter method:\n\tid: {}\n\tname: {} \n\titems: {}", this.id, this.name, String.join(", ", this.items));
    return System.currentTimeMillis();                                                                                         
}                                                                                                                              
                                                                                                                               
private Long reset(String... name) {                                                                                           
    this.id = UUID.randomUUID().toString();                                                                                    
    this.name = name[0];                                                                                                       
    this.items = null;                                                                                                         
    logInfo("\nSingle parameter varargs method:\n\tname: {}", this.name);                                                      
    return System.currentTimeMillis();                                                                                         
}                                                                                                                              
                                                                                                                               
private Long reset(String name) {                                                                                              
    this.id = UUID.randomUUID().toString();                                                                                    
    this.name = name;                                                                                                          
    this.items = null;                                                                                                         
    logInfo("\nSingle parameter method:\n\tname: {}", this.name);                                                              
    return System.currentTimeMillis();                                                                                         
}                                                                                                                              
                                                                                                                               
private Long reset() {                                                                                                         
    this.id = UUID.randomUUID().toString();                                                                                    
    this.name = "no name";                                                                                                     
    this.items = null;                                                                                                         
    logInfo("\nNo parameter method:\n\tname: {}", this.name);                                                                  
    return System.currentTimeMillis();                                                                                         
}                  </pre>



<p>&#8230; And now let&#8217;s see the code needed to bind and call the generated functional interfaces:  </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">ComponentContainer componentContainer = ComponentContainer.getInstance();                                                                           
FunctionalInterfaceFactory fIF = componentContainer.getFunctionalInterfaceFactory();                                                                
                                                                                                                                                    
MultiParamsFunction&lt;Long> methodInvokerZero = fIF.getOrCreate(Service.class, "reset", String.class, String.class, String[].class);                  
Long currentTimeMillis = methodInvokerZero.apply(service, UUID.randomUUID().toString(), "Service Zero New Name", new String[] {"item 3", "item 4"});
                                                                                                                                                    
MultiParamsFunction&lt;Long> methodInvokerOne = fIF.getOrCreate(Service.class, "reset", String.class, String[].class);                                 
currentTimeMillis = methodInvokerOne.apply(service, "Service One", new String[] {"item 1", "item 2"});                                              
                                                                                                                                                    
BiFunction&lt;Service, String[], Long> methodInvokerTwo = fIF.getOrCreate(Service.class, "reset", String[].class);                                     
currentTimeMillis = methodInvokerTwo.apply(service, new String[] {"Service Two"});                                                                  
                                                                                                                                                    
BiFunction&lt;Service, String, Long> methodInvokerThree = fIF.getOrCreate(Service.class, "reset", String.class);                                       
currentTimeMillis = methodInvokerThree.apply(service, "Service Three");                                                                             
                                                                                                                                                    
Function&lt;Service, Long> methodInvokerFour = fIF.getOrCreate(Service.class, "reset");                                                                
currentTimeMillis = methodInvokerFour.apply(service);   </pre>



<br><h3>
<a id="void-methods-binding" class="anchor" href="#void-methods-binding" aria-hidden="true"></a>Void methods binding</h3>



<hr class="wp-block-separator"/>



<p>To bind methods with boolean return to functional interfaces we will use the following methods: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">private void voidReset(String id, String name, String... items) {                                                                   
    this.id = id;                                                                                                                   
    this.name = name;                                                                                                               
    this.items = items;                                                                                                             
    logInfo("\nMultiparameter void method:\n\tid: {}\n\tname: {} \n\titems: {}", this.id, this.name, String.join(", ", this.items));
}                                                                                                                                   
                                                                                                                                    
private void voidReset(String name, String... items) {                                                                              
    this.id = UUID.randomUUID().toString();                                                                                         
    this.name = name;                                                                                                               
    this.items = items;                                                                                                             
    logInfo("\nMultiparameter void method:\n\tname: {} \n\titems: {}", this.name, String.join(", ", this.items));                   
}                                                                                                                                   
                                                                                                                                    
private void voidReset(String... name) {                                                                                            
    this.id = UUID.randomUUID().toString();                                                                                         
    this.name = name[0];                                                                                                            
    this.items = null;                                                                                                              
    logInfo("\nSingle parameter void varargs method:\n\tname: {}", this.name);                                                      
}                                                                                                                                   
                                                                                                                                    
private void voidReset(String name) {                                                                                               
    this.id = UUID.randomUUID().toString();                                                                                         
    this.name = "no name";                                                                                                          
    this.items = null;                                                                                                              
    logInfo("\nSingle parameter void method:\n\tname: {}", this.name);                                                              
}                                                                                                                                   
                                                                                                                                    
private void voidReset() {                                                                                                          
    this.id = UUID.randomUUID().toString();                                                                                         
    this.name = "no name";                                                                                                          
    this.items = null;                                                                                                              
    logInfo("\nNo parameter void method:\n\tname: {}", this.name);                                                                  
}          </pre>



<p> &#8230; And now let&#8217;s see the code needed to bind and call the generated functional interfaces: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">ComponentContainer componentContainer = ComponentContainer.getInstance();                                                       
FunctionalInterfaceFactory fIF = componentContainer.getFunctionalInterfaceFactory();                                            
                                                                                                                                
MultiParamsConsumer methodInvokerZero = fIF.getOrCreate(Service.class, "voidReset", String.class, String.class, String[].class);
methodInvokerZero.accept(service, UUID.randomUUID().toString(), "Service Zero New Name", new String[] {"item 3", "item 4"});    
                                                                                                                                
MultiParamsConsumer methodInvokerOne = fIF.getOrCreate(Service.class, "voidReset", String.class, String[].class);               
methodInvokerOne.accept(service, "Service One", new String[] {"item 1", "item 2"});                                             
                                                                                                                                
BiConsumer&lt;Service, String[]> methodInvokerTwo = fIF.getOrCreate(Service.class, "voidReset", String[].class);                   
methodInvokerTwo.accept(service, new String[] {"Service Two"});                                                                 
                                                                                                                                
BiConsumer&lt;Service, String> methodInvokerThree = fIF.getOrCreate(Service.class, "voidReset", String.class);                     
methodInvokerThree.accept(service, "Service Three");                                                                            
                                                                                                                                
Consumer&lt;Service> methodInvokerFour = fIF.getOrCreate(Service.class, "voidReset");                                              
methodInvokerFour.accept(service);            </pre>



<br><h3>
<a id="binding-boolean-return" class="anchor" href="#binding-boolean-return" aria-hidden="true"></a>Binding to methods with boolean return</h3>



<hr class="wp-block-separator"/>



<p>To bind methods with boolean return to functional interfaces we will use the following methods: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">private boolean resetWithBooleanReturn(String id, String name, String... items) {                                                                  
    this.id = id;                                                                                                                                  
    this.name = name;                                                                                                                              
    this.items = items;                                                                                                                            
    logInfo("\nMultiparameter method with boolean return:\n\tid: {}\n\tname: {} \n\titems: {}", this.id, this.name, String.join(", ", this.items));
    return true;                                                                                                                                   
}                                                                                                                                                  
                                                                                                                                                   
private boolean resetWithBooleanReturn(String name, String... items) {                                                                             
    this.id = UUID.randomUUID().toString();                                                                                                        
    this.name = name;                                                                                                                              
    this.items = items;                                                                                                                            
    logInfo("\nMultiparameter method with boolean return:\n\tid: {}\n\tname: {} \n\titems: {}", this.id, this.name, String.join(", ", this.items));
    return true;                                                                                                                                   
}                                                                                                                                                  
                                                                                                                                                   
private boolean resetWithBooleanReturn(String... name) {                                                                                           
    this.id = UUID.randomUUID().toString();                                                                                                        
    this.name = name[0];                                                                                                                           
    this.items = null;                                                                                                                             
    logInfo("\nSingle parameter varargs method with boolean return:\n\tname: {}", this.name);                                                      
    return true;                                                                                                                                   
}                                                                                                                                                  
                                                                                                                                                   
private boolean resetWithBooleanReturn(String name) {                                                                                              
    this.id = UUID.randomUUID().toString();                                                                                                        
    this.name = name;                                                                                                                              
    this.items = null;                                                                                                                             
    logInfo("\nSingle parameter method with boolean return:\n\tname: {}", this.name);                                                              
    return true;                                                                                                                                   
}       </pre>



<p>&#8230; And now let&#8217;s see the code needed to bind and call the generated functional interfaces: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">ComponentContainer componentContainer = ComponentContainer.getInstance();                                                                     
FunctionalInterfaceFactory fIF = componentContainer.getFunctionalInterfaceFactory();                                                          
                                                                                                                                              
MultiParamsPredicate methodInvokerZero = fIF.getOrCreate(Service.class, "resetWithBooleanReturn", String.class, String.class, String[].class);
boolean executed = methodInvokerZero.test(service, UUID.randomUUID().toString(), "Service Zero New Name", new String[] {"item 3", "item 4"}); 
                                                                                                                                              
MultiParamsPredicate methodInvokerOne = fIF.getOrCreate(Service.class, "resetWithBooleanReturn", String.class, String[].class);               
executed = methodInvokerOne.test(service, "Service One", new String[] {"item 1", "item 2"});                                                  
                                                                                                                                              
BiPredicate&lt;Service, String[]> methodInvokerTwo = fIF.getOrCreate(Service.class, "resetWithBooleanReturn", String[].class);                   
executed = methodInvokerTwo.test(service, new String[] {"Service Two"});                                                                      
                                                                                                                                              
BiPredicate&lt;Service, String> methodInvokerThree = fIF.getOrCreate(Service.class, "resetWithBooleanReturn", String.class);                     
executed = methodInvokerThree.test(service, "Service Three");                                                                                 
                                                                                                                                              
Predicate&lt;Service> methodInvokerFour = fIF.getOrCreate(Service.class, "resetWithBooleanReturn");                                              
executed = methodInvokerFour.test(service);                      </pre>
</div>