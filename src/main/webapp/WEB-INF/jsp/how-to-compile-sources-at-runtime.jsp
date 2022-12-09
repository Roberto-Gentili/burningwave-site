<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p class="has-2-columns w-two-one-use-case">Before compiling sources at runtime you must create them: to do this follow <strong><a href="/how-to-generate-sources-at-runtime/">this guide</a></strong>. If you need to compile the sources and load the generated classes at runtime it is suggested to use the <strong><a href="/generating-classes-at-runtime-and-invoking-their-methods-with-and-without-the-use-of-reflection/">ClassFactory</a></strong>, otherwise if you just need to compile the sources you can use the <strong>JavaMemoryCompiler</strong> as follow:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package source.compilation.test;


import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.classes.JavaMemoryCompiler;
import org.burningwave.core.classes.JavaMemoryCompiler.Compilation;
import org.burningwave.core.concurrent.QueuedTasksExecutor.ProducerTask;
import org.burningwave.core.io.FileSystemItem;

import source.generation.test.SourceGenerationTester;

public class SourceCompilationTester {
    
    
    public static void main(String[] args) throws ClassNotFoundException {
        ComponentContainer componentContainer = ComponentContainer.getInstance();
        JavaMemoryCompiler javaMemoryCompiler = componentContainer.getJavaMemoryCompiler();
        ProducerTask&lt;Compilation.Result> compilationTask = javaMemoryCompiler.compile(
            Compilation.Config.forUnitSourceGenerator(
                SourceGenerationTester.generate()
            )
            .storeCompiledClassesTo(
                System.getProperty("user.home") + "/Desktop/classes"
            )
        );
        
        Compilation.Result compilationResult = compilationTask.join();
        
        System.out.println("\n\tAbsolute path of compiled file: " + 
            compilationResult.getClassPath()
            .findFirstInAllChildren(
                FileSystemItem.Criteria.forAllFileThat(FileSystemItem::isFile)
            ).getAbsolutePath() + "\n"
        );
    }
    
}</pre>



<p><strong>You can also load the generated class files</strong>:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package source.compilation.test;

import static org.burningwave.core.assembler.StaticComponentContainer.ClassLoaders;
import static org.burningwave.core.assembler.StaticComponentContainer.Methods;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.classes.JavaMemoryCompiler;
import org.burningwave.core.classes.JavaMemoryCompiler.Compilation;
import org.burningwave.core.concurrent.QueuedTasksExecutor.ProducerTask;

import source.generation.test.SourceGenerationTester;

public class SourceCompilationTester {
    
    
    public static void main(String[] args) throws ClassNotFoundException {
        ComponentContainer componentContainer = ComponentContainer.getInstance();
        JavaMemoryCompiler javaMemoryCompiler = componentContainer.getJavaMemoryCompiler();
        ProducerTask&lt;Compilation.Result> compilationTask = javaMemoryCompiler.compile(
            Compilation.Config.forUnitSourceGenerator(
                SourceGenerationTester.generate()
            )
            .storeCompiledClassesTo(
                System.getProperty("user.home") + "/Desktop/classes"
            )
        );
        
        Compilation.Result compilattionResult = compilationTask.join();
        
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        ClassLoaders.addClassPaths(classLoader, compilattionResult.getDependencies());
        ClassLoaders.addClassPath(classLoader, compilattionResult.getClassPath().getAbsolutePath());
        Class&lt;?> cls = classLoader.loadClass("source.generation.test.GeneratedClass");
        Methods.invokeStaticDirect(cls, "main", new Object[] {new String[] {"Hello", "world!"}});
    }
    
}</pre>
</div>