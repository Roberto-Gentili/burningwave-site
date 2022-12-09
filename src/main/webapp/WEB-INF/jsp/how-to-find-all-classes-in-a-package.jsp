<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p>In order to find all classes in a package in Java we need to use the <strong><a href="/the-class-hunter-in-depth-look-to-and-configuration-guide/">ClassHunter</a></strong>. So let&#8217;s start by adding the following dependency to our <em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Then next steps are the following:</p>



<ul class="normal"><li>retrieving the ClassHunter through the <strong>ComponentContainer</strong></li><li>defining a regular expression that we must pass to the <strong>ClassCriteria </strong>object that will be injected into the <strong>SearchConfig </strong>object</li><li>calling the<strong> findBy </strong>method that loads in the cache all loadable classes of the indicated paths, then applies the criteria filter and then returns the <strong>SearchResult </strong>object which contains the classes that match the criteria</li></ul>



<p><strong>The fastest and most optimized way to find all the classes of a package is by iterating the resources accessible through ClassLoade</strong>r thus avoiding that ClassLoader loads the classes that are outside the scanned paths: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.ClassHunter.SearchResult;
import org.burningwave.core.classes.SearchConfig;
    
public class ClassForPackageFinder {
    
    public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        ClassHunter classHunter = componentSupplier.getClassHunter();
        
        try (SearchResult result = classHunter.findBy(
        	//Highly optimized scanning by filtering resources before loading from ClassLoader
    	    SearchConfig.forResources(
    	        "org/springframework"
    	    )
    	)) {
    	    return result.getClasses();
    	}
    }
    
}</pre>



<p><strong>Another fast way to get all the classes in a package is to add a filter that will be applied when scanning the files and before loading the classes:</strong></p>



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



<p>In the <strong>forPaths </strong>method you can add all absolute paths you want: <em>both <strong>folders</strong>, <strong>zip</strong>, <strong>jar</strong>, <strong>ear</strong>, <strong>war </strong>and <strong>jmod </strong>files will be recursively scanned</em>. For example you can add: &#8220;C:\Users\user\.m2&#8221;, or a path of an ear file that contains nested war with nested jar files. With the line of code in the example above the search will be executed on runtime class paths and, on java 9 and later, also on .jmod files contained in jmods folder of the Java home. You can also instantiate the SearchConfig object without calling the  forPaths method: in this case the scan will be executed through the default configured paths (see &#8220;<a href="../in-depth-look-to-and-configuration-guide/index.html">The ClassHunter: in depth look to and configuration guide</a>&#8220;). </p>



<br>



<h3>Finding all classes that have package name that matches a regex</h3>



<p>In the following example we are going to find all classes that have package name that matches a regex and in particular we look for all classes whose package name contains &#8220;springframework&#8221; string using the ClassCriteria: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.SearchConfig;
    
public class Finder {
    
    public Collection&lt;Class&lt;?>> find() {
    	ComponentSupplier componentSupplier = ComponentContainer.getInstance();
    	ClassHunter classHunter = componentSupplier.getClassHunter();

    	SearchConfig searchConfig = SearchConfig.byCriteria(
    	    ClassCriteria.create().allThoseThatMatch((cls) -> {
    	    	String packageName = cls.getPackage().getName();
    	        return packageName != null &amp;&amp; packageName.matches(".*springframework.*");
    	    })
    	);

    	try (ClassHunter.SearchResult searchResult = classHunter.findBy(searchConfig)) {
    	    return searchResult.getClasses();
    	}
    }
    
}</pre>



<br>



<h3>Finding all annotated classes of a package without considering the classes hierarchy</h3>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.ConstructorCriteria;
import org.burningwave.core.classes.FieldCriteria;
import org.burningwave.core.classes.MethodCriteria;
import org.burningwave.core.classes.SearchConfig;
    
public class Finder {
    
    
    public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        ClassHunter classHunter = componentSupplier.getClassHunter();
        
        try (ClassHunter.SearchResult result = classHunter.findBy(
                //Highly optimized scanning by filtering resources before loading from ClassLoader
                SearchConfig.forResources(
                    "org/springframework"
                ).by(
                    ClassCriteria.create().allThoseThatMatch((cls) -> {
                        return cls.getAnnotations() != null &amp;&amp; cls.getAnnotations().length > 0;
                    }).or().byMembers(
                        MethodCriteria.withoutConsideringParentClasses().allThoseThatMatch((method) -> {
                            return method.getAnnotations() != null &amp;&amp; method.getAnnotations().length > 0;
                        })
                    ).or().byMembers(
                        FieldCriteria.withoutConsideringParentClasses().allThoseThatMatch((field) -> {
                            return field.getAnnotations() != null &amp;&amp; field.getAnnotations().length > 0;
                        })
                    ).or().byMembers(
                        ConstructorCriteria.withoutConsideringParentClasses().allThoseThatMatch((ctor) -> {
                            return ctor.getAnnotations() != null &amp;&amp; ctor.getAnnotations().length > 0;
                        })
                    )
                )
            )
        ) {
            return result.getClasses();
        }
    } 
}</pre>



<br>



<h3> Finding all annotated classes of a package by considering the classes hierarchy </h3>



<p></p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.ClassHunter.SearchResult;
import org.burningwave.core.classes.ConstructorCriteria;
import org.burningwave.core.classes.FieldCriteria;
import org.burningwave.core.classes.MethodCriteria;
import org.burningwave.core.classes.SearchConfig;
    
public class ClassForPackageAndAnnotationFinder {
    
    public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        ClassHunter classHunter = componentSupplier.getClassHunter();
        
        try (
                SearchResult result = classHunter.findBy(
                //Highly optimized scanning by filtering resources before loading from ClassLoader
                SearchConfig.forResources(
                    "org/springframework"
                ).by(
                    ClassCriteria.create().allThoseThatHaveAMatchInHierarchy((cls) -> {
                        return cls.getAnnotations() != null &amp;&amp; cls.getAnnotations().length > 0;
                    }).or().byMembers(
                        MethodCriteria.forEntireClassHierarchy().allThoseThatMatch((method) -> {
                            return method.getAnnotations() != null &amp;&amp; method.getAnnotations().length > 0;
                        })
                    ).or().byMembers(
                        FieldCriteria.forEntireClassHierarchy().allThoseThatMatch((field) -> {
                            return field.getAnnotations() != null &amp;&amp; field.getAnnotations().length > 0;
                        })
                    ).or().byMembers(
                        ConstructorCriteria.forEntireClassHierarchy().allThoseThatMatch((ctor) -> {
                            return ctor.getAnnotations() != null &amp;&amp; ctor.getAnnotations().length > 0;
                        })
                    )
                )
            )
        ) {
            return result.getClasses();
        }
    }
    
}</pre>



<br>



<h3>Finding all classes of a package that have a particular annotation on at least one Field without considering the classes hierarchy </h3>



<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import javax.validation.constraints.NotNull;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.FieldCriteria;
import org.burningwave.core.classes.SearchConfig;
    
public class Finder {
    
    public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        ClassHunter classHunter = componentSupplier.getClassHunter();
        
        try (
        	ClassHunter.SearchResult result = classHunter.findBy(
                //Highly optimized scanning by filtering resources before loading from ClassLoader
                SearchConfig.forResources(
                    "org/springframework"
                ).by(
                    ClassCriteria.create().byMembers(
                        FieldCriteria.withoutConsideringParentClasses().allThoseThatMatch((field) -> {
                            return field.getAnnotation(NotNull.class) != null;
                        })
                    )
                )
            )
        ) {
            return result.getClasses();
        }
    }
    
}</pre>



<br>



<h3>Finding all classes of a package that have a particular annotation on at least one Field by considering the classes hierarchy </h3>



<pre class="EnlighterJSRAW" data-enlighter-language="generic" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import java.util.Collection;

import javax.validation.constraints.NotNull;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassCriteria;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.classes.FieldCriteria;
import org.burningwave.core.classes.SearchConfig;
    
public class Finder {
    
    public Collection&lt;Class&lt;?>> find() {
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        ClassHunter classHunter = componentSupplier.getClassHunter();
        
        try (
        		ClassHunter.SearchResult result = classHunter.findBy(
                //Highly optimized scanning by filtering resources before loading from ClassLoader
                SearchConfig.forResources(
                    "org/springframework"
                ).by(
                    ClassCriteria.create().byMembers(
                        FieldCriteria.forEntireClassHierarchy().allThoseThatMatch((field) -> {
                            return field.getAnnotation(NotNull.class) != null;
                        })
                    )
                )
            )
        ) {
            return result.getClasses();
        }
    }
    
}</pre>
</div>