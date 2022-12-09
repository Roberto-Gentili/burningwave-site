<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>For getting a property of a Java bean through path, we initially need to add the following dependency to our <em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>For this example we will use these Java beans:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package org.burningwave.core.bean;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Complex {
    private Complex.Data data;
    
    public Complex() {
        setData(new Data());
    }
    
    
    public Complex.Data getData() {
        return data;
    }
    
    public void setData(Complex.Data data) {
        this.data = data;
    }


    public static class Data {
        private Data.Item[][] items;
        private List&lt;Data.Item> itemsList;
        private Map&lt;String, Data.Item[][]> itemsMap;
        
        public Data() {
            items = new Data.Item[][] {
                new Data.Item[] {
                    new Item("Hello"),
                    new Item("World!"),
                    new Item("How do you do?")
                },
                new Data.Item[] {
                    new Item("How do you do?"),
                    new Item("Hello"),
                    new Item("Bye")
                }
            };
            itemsMap = new LinkedHashMap&lt;>();
            itemsMap.put("items", items);
        }
        
        public Data.Item[][] getItems() {
            return items;
        }
        public void setItems(Data.Item[][] items) {
            this.items = items;
        }
        
        public List&lt;Data.Item> getItemsList() {
            return itemsList;
        }
        public void setItemsList(List&lt;Data.Item> itemsList) {
            this.itemsList = itemsList;
        }
        
        public Map&lt;String, Data.Item[][]> getItemsMap() {
            return itemsMap;
        }
        public void setItemsMap(Map&lt;String, Data.Item[][]> itemsMap) {
            this.itemsMap = itemsMap;
        }
        
        public static class Item {
            private String name;
            
            public Item(String name) {
                this.name = name;
            }
            
            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }
        }
    }
}</pre>



<p> &#8230; And now we get some properties through path:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import static org.burningwave.core.assembler.StaticComponentContainer.ByFieldOrByMethodPropertyAccessor;
import static org.burningwave.core.assembler.StaticComponentContainer.ByMethodOrByFieldPropertyAccessor;

import org.burningwave.core.bean.Complex;
import org.burningwave.core.reflection.PropertyAccessor;

public class GetPropertyThroughPath{
    
    public void tryGet() {
        Complex complex = new Complex();
        //This type of property accessor try to access by field introspection: if no field was found
        //it will search getter method and invokes it
        String nameFromObjectInArray = ByFieldOrByMethodPropertyAccessor.get(complex, "data.items[1][0].name");
        String nameFromObjectMap = ByFieldOrByMethodPropertyAccessor.get(complex, "data.itemsMap[items][1][1].name");
        System.out.println(nameFromObjectInArray);
        System.out.println(nameFromObjectMap);
        //This type of property accessor looks for getter method and invokes it: if no getter method was found
        //it will search for field and try to retrieve it
        nameFromObjectInArray = ByMethodOrByFieldPropertyAccessor.get(complex, "data.items[1][2].name");
        nameFromObjectMap = ByMethodOrByFieldPropertyAccessor.get(complex, "data.itemsMap[items][1][1].name");
        System.out.println(nameFromObjectInArray);
        System.out.println(nameFromObjectMap);
    }
    
}</pre>



<p></p>
</div>