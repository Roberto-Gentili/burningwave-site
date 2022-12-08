<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="wp-block-column">
<p><strong>Burningwave Core</strong>&nbsp;is based on the concept of component and component container. A&nbsp;<strong>component</strong>&nbsp;is a dynamic object that perform functionality related to the domain it belong to. A&nbsp;<strong>component container</strong>&nbsp;contains a set of dynamic components and could be of two types:</p>



<ul><li><strong>static component container</strong></li><li><strong>dynamic component container</strong></li></ul>



<p>More than one dynamic container can be created, while only one static container can exists.</p>



<h3>Static component container<br></h3>



<p>It is represented by the&nbsp;<strong>org.burningwave.core.assembler.StaticComponentContainer</strong>&nbsp;class that provides the following fields for each component supplied: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">public static final org.burningwave.core.concurrent.QueuedTasksExecutor.Group BackgroundExecutor;
public static final org.burningwave.core.jvm.BufferHandler BufferHandler;
public static final org.burningwave.core.classes.FieldAccessor ByFieldOrByMethodPropertyAccessor;
public static final org.burningwave.core.classes.FieldAccessor ByMethodOrByFieldPropertyAccessor;
public static final org.burningwave.core.Cache Cache;
public static final org.burningwave.core.classes.Classes Classes;
public static final org.burningwave.core.classes.Classes.Loaders ClassLoaders;
public static final org.burningwave.core.classes.Constructors Constructors;
public static final io.github.toolfactory.jvm.Driver Driver;
public static final org.burningwave.core.io.FileSystemHelper FileSystemHelper;
public static final org.burningwave.core.classes.Fields Fields;
public static final org.burningwave.core.iterable.Properties GlobalProperties;
public static final org.burningwave.core.iterable.IterableObjectHelper IterableObjectHelper;
public static final io.github.toolfactory.jvm.Info JVMInfo;
public static final org.burningwave.core.ManagedLogger.Repository ManagedLoggerRepository;
public static final org.burningwave.core.classes.Members Members;
public static final org.burningwave.core.classes.Methods Methods;
public static final org.burningwave.core.classes.Modules Modules; //Null on JDK 8
public static final org.burningwave.core.Objects Objects;
public static final org.burningwave.core.Strings.Paths Paths;
public static final org.burningwave.core.io.Resources Resources;
public static final org.burningwave.core.classes.SourceCodeHandler SourceCodeHandler;
public static final org.burningwave.core.io.Streams Streams;
public static final org.burningwave.core.Strings Strings;
public static final org.burningwave.core.concurrent.Synchronizer Synchronizer;
public static final org.burningwave.core.SystemProperties SystemProperties;
public static final org.burningwave.core.concurrent.Thread.Holder ThreadHolder;
public static final org.burningwave.core.concurrent.Thread.Supplier ThreadSupplier;</pre>



<p>&#8230; That can be used within your application, simply adding a static import to your compilation unit, i.e.: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import static org.burningwave.core.assembler.StaticComponentContainer.ClassLoaders;
import static org.burningwave.core.assembler.StaticComponentContainer.ManagedLoggerRepository;

public class UseOfStaticComponentsExample &#123;
    
    public void yourMethod()&#123;
        ManagedLoggerRepository.logInfo(
            UseOfStaticComponentsExample.class::getName,
            "Master class loader is &#123;&#125;",
            ClassLoaders.getMaster(Thread.currentThread().getContextClassLoader())
        );
    &#125;

&#125;</pre>



<h4><a id="configuration-1" class="anchor" href="#configuration-1" aria-hidden="true">&nbsp;</a></h4>



<h4>Configuration</h4>



<p class="has-text-align-left">The configuration of this type of container is done via&nbsp;<strong>burningwave.static.properties</strong>&nbsp;file that must be located in the base path of your class path: the library looks for all files with this name and&nbsp;<strong>merges them according to to the property&nbsp;<code>priority-of-this-configuration</code>&nbsp;contained within it</strong>&nbsp;which is optional but becomes mandatory if in the base class paths there are multiple files with the file name indicated above.&nbsp;It is possible to change the file name of the configuration file  through the method &nbsp;<code>org.burningwave.core.assembler.StaticComponentContainer.Configuration.Default.setFileName</code>&nbsp;before using the static component container or if you need <strong>to integrate the configuration properties into Spring</strong> you can follow&nbsp;<a href="../forum/topic/how-can-i-integrate-the-configuration-properties-in-spring/index.html#postid-102">this guide</a>. <strong>If no configuration file is found, the library programmatically sets the default configuration with following values</strong>:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">background-executor.all-tasks-monitoring.enabled=\
	true
background-executor.all-tasks-monitoring.interval=\
	30000
background-executor.all-tasks-monitoring.logger.enabled=\
	false
background-executor.all-tasks-monitoring.minimum-elapsed-time-to-consider-a-task-as-probable-dead-locked=\
	300000
#Other possible values are: 'mark as probable dead locked',
#'interrupt', 'kill'. It is also possible to combine these values, e.g.:
#background-executor.all-tasks-monitoring.probable-dead-locked-tasks-handling.policy=\
#	mark as probable dead locked, kill
background-executor.all-tasks-monitoring.probable-dead-locked-tasks-handling.policy=\
	log only
background-executor.queued-task-executor[0].name=\
	Low priority tasks
background-executor.queued-task-executor[0].priority=\
	1
background-executor.queued-task-executor[1].name=\
	Normal priority tasks
background-executor.queued-task-executor[1].priority=\
	5
background-executor.queued-task-executor[2].name=\
	High priority tasks
background-executor.queued-task-executor[2].priority=\
	10
background-executor.task-creation-tracking.enabled=\
	$&#123;background-executor.all-tasks-monitoring.enabled&#125;
banner.additonal-informations=\
	$&#123;Implementation-Title&#125; $&#123;Implementation-Version&#125;
banner.additonal-informations.retrieve-from-manifest-file-with-implementation-title=\
	Burningwave Core
banner.hide=\
	false
banner.file=\
	org/burningwave/banner.bwb
buffer-handler.default-buffer-size=\
	1024
buffer-handler.default-allocation-mode=\
	ByteBuffer::allocateDirect
group-name-for-named-elements=\
	Burningwave
iterable-object-helper.default-values-separator=\
	;
iterable-object-helper.parallel-iteration.applicability.default-minimum-collection-size=\
	2
iterable-object-helper.parallel-iteration.applicability.max-runtime-thread-count-threshold=\
	autodetect
iterable-object-helper.parallel-iteration.applicability.output-collection-enabled-types=\
	java.util.concurrent.ConcurrentHashMap$CollectionView;\
	java.util.Collections$SynchronizedCollection;\
	java.util.concurrent.CopyOnWriteArrayList;\
	java.util.concurrent.CopyOnWriteArraySet;\
	java.util.concurrent.BlockingQueue;\
	java.util.concurrent.ConcurrentSkipListSet;\
	java.util.concurrent.ConcurrentSkipListMap$EntrySet;\
	java.util.concurrent.ConcurrentSkipListMap$KeySet;\
	java.util.concurrent.ConcurrentSkipListMap$Values;
#This property is optional and it is possible to use a custom JVM Driver which implements
#the io.github.toolfactory.jvm.Driver interface.
#Other possible values are: io.github.toolfactory.jvm.DefaultDriver, 
#org.burningwave.jvm.HybridDriver, org.burningwave.jvm.NativeDriver
jvm.driver.type=\
	org.burningwave.jvm.DynamicDriver
jvm.driver.init=\
	false
#With this value the library will search if org.slf4j.Logger is present and, in this case,
#the SLF4JManagedLoggerRepository will be instantiated, otherwise
#the SimpleManagedLoggerRepository will be instantiated
managed-logger.repository=\
	autodetect
#to increase performance set it to false
managed-logger.repository.enabled=\
	true
managed-logger.repository.logging.warn.disabled-for=\
	org.burningwave.core.assembler.ComponentContainer$ClassLoader;\
	org.burningwave.core.classes.MemoryClassLoader;\
	org.burningwave.core.classes.PathScannerClassLoader;
modules.export-all-to-all=\
	true
#mandatory if more burningwave.static.properties file are in the class paths
priority-of-this-configuration=0
resource-releaser.enabled=true
synchronizer.all-threads-monitoring.enabled=\
	false
synchronizer.all-threads-monitoring.interval=\
	90000
thread-supplier.default-daemon-flag-value=\
	true
thread-supplier.default-thread-priority=\
	5
thread-supplier.max-detached-thread-count=\
	$&#123;thread-supplier.max-poolable-thread-count&#125;
thread-supplier.max-detached-thread-count.elapsed-time-threshold-from-last-increase-for-gradual-decreasing-to-initial-value=\
	30000
thread-supplier.max-detached-thread-count.increasing-step=\
	autodetect
thread-supplier.max-poolable-thread-count=\
	autodetect
thread-supplier.poolable-thread-request-timeout=\
	6000</pre>



<p class="has-text-align-left"><strong>If in your custom burningwave.static.properties file one of this default properties is not found, the relative default value here in the box above is assumed</strong>.&nbsp;<a href="https://github.com/burningwave/core/blob/master/src/test/resources/burningwave.static.properties#L1">Here an example of a&nbsp;<strong>burningwave.static.properties</strong>&nbsp;file</a>. </p>



<h3><a id="dynamic-component-container" class="anchor" href="#dynamic-component-container" aria-hidden="true"></a>Dynamic component container <br></h3>



<p class="has-text-align-left">It is represented by the&nbsp;<strong>org.burningwave.core.assembler.ComponentContainer</strong>&nbsp;class that provides the following methods for each component supplied: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">public ByteCodeHunter getByteCodeHunter();
public ClassFactory getClassFactory();
public ClassHunter getClassHunter();
public ClassPathHelper getClassPathHelper();
public ClassPathHunter getClassPathHunter();
public CodeExecutor getCodeExecutor();
public FunctionalInterfaceFactory getFunctionalInterfaceFactory();
public JavaMemoryCompiler getJavaMemoryCompiler();
public PathHelper getPathHelper();
public PathScannerClassLoader getPathScannerClassLoader();</pre>



<p class="has-text-align-left">&#8230; That can be used within your application, simply as follow: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="true" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package org.burningwave.core.examples.componentcontainer;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.ClassFactory;
import org.burningwave.core.classes.ClassHunter;
import org.burningwave.core.io.PathHelper;
import java.util.Properties;

public class RetrievingDynamicComponentContainerAndComponents &#123;

    public static void execute() throws Throwable &#123;
        //In this case we are retrieving the singleton component container instance
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        
        //In this case we are creating a component container by using a custom configuration file
        ComponentSupplier customComponentSupplier = ComponentContainer.create("your-custom-properties-file.properties");
        
        //In this case we are creating a component container programmatically by using a custom properties object
        Properties configProps = new Properties();
        configProps.put(ClassFactory.Configuration.Key.DEFAULT_CLASS_LOADER, Thread.currentThread().getContextClassLoader());
        configProps.put(ClassHunter.Configuration.Key.DEFAULT_PATH_SCANNER_CLASS_LOADER, componentSupplier.getPathScannerClassLoader());
        ComponentSupplier customComponentSupplier2 = ComponentContainer.create(configProps);
        
        PathHelper pathHelper = componentSupplier.getPathHelper();
        ClassFactory classFactory = customComponentSupplier.getClassFactory();
        ClassHunter classHunter = customComponentSupplier2.getClassHunter();
       
    &#125;   
    
&#125;</pre>



<h4><a id="configuration-2" class="anchor" href="#configuration-2" aria-hidden="true">&nbsp;</a></h4>



<h4>Configuration</h4>



<p class="has-text-align-left">The configuration of this type of container can be done via Properties file or programmatically via a Properties object. If you use the singleton instance obtained via&nbsp;<strong><code>ComponentContainer.getInstance()</code></strong>&nbsp;method, you must create a&nbsp;<strong>burningwave.properties</strong>&nbsp;file and put it on base path of your class path project: the library looks for all files with this name and&nbsp;<strong>merges them according to to the property&nbsp;<code>priority-of-this-configuration</code>&nbsp;contained within it</strong>&nbsp;which is optional but becomes mandatory if in the base class paths there are multiple files with the file name indicated above.&nbsp;It is possible to change the file name of the configuration file  through the method &nbsp;<code>org.burningwave.core.assembler.ComponentContainer.Configuration.Default.setFileName</code>&nbsp;before using the component container or if you need <strong>to integrate the configuration properties into Spring</strong> you can follow&nbsp;<a href="../forum/topic/how-can-i-integrate-the-configuration-properties-in-spring/index.html#postid-102">this guide</a>. <strong>If no configuration file is found, the library programmatically sets the default configuration with following values</strong>: </p>



<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">byte-code-hunter.default-path-scanner-class-loader=\
	(Supplier&lt;PathScannerClassLoader>)() -> ((ComponentSupplier)parameter[0]).getPathScannerClassLoader()
#This variable is empty by default and can be valorized by developer and it is
#included by 'byte-code-hunter.default-path-scanner-class-loader.supplier.imports' property
byte-code-hunter.default-path-scanner-class-loader.supplier.additional-imports=
byte-code-hunter.default-path-scanner-class-loader.supplier.imports=\
	$&#123;code-executor.common.imports&#125;;\
	$&#123;byte-code-hunter.default-path-scanner-class-loader.supplier.additional-imports&#125;;\
	org.burningwave.core.classes.PathScannerClassLoader;
byte-code-hunter.default-path-scanner-class-loader.supplier.name=\
	org.burningwave.core.classes.DefaultPathScannerClassLoaderRetrieverForByteCodeHunter
byte-code-hunter.new-isolated-path-scanner-class-loader.search-config.check-file-option=\
	$&#123;hunters.default-search-config.check-file-option&#125;
class-factory.byte-code-hunter.search-config.check-file-option=\
	$&#123;hunters.default-search-config.check-file-option&#125;
#default classloader used by the ClassFactory to load generated classes
class-factory.default-class-loader=\
	(Supplier&lt;ClassLoader>)() -> ((ComponentSupplier)parameter[0]).getPathScannerClassLoader()
#This variable is empty by default and can be valorized by developer and it is
#included by 'class-factory.default-class-loader.supplier.imports' property
class-factory.default-class-loader.supplier.additional-imports=
class-factory.default-class-loader.supplier.imports=\
	$&#123;code-executor.common.imports&#125;;\
	$&#123;class-factory.default-class-loader.supplier.additional-imports&#125;;\
	org.burningwave.core.classes.PathScannerClassLoader;
class-factory.default-class-loader.supplier.name=\
	org.burningwave.core.classes.DefaultClassLoaderRetrieverForClassFactory
class-hunter.default-path-scanner-class-loader=\
	(Supplier&lt;PathScannerClassLoader>)() -> ((ComponentSupplier)parameter[0]).getPathScannerClassLoader()
#This variable is empty by default and can be valorized by developer and it is
#included by 'class-hunter.default-path-scanner-class-loader.supplier.imports' property
class-hunter.default-path-scanner-class-loader.supplier.additional-imports=
class-hunter.default-path-scanner-class-loader.supplier.imports=\
	$&#123;code-executor.common.imports&#125;;\
	$&#123;class-hunter.default-path-scanner-class-loader.supplier.additional-imports&#125;;\
	org.burningwave.core.classes.PathScannerClassLoader;
class-hunter.default-path-scanner-class-loader.supplier.name=\
	org.burningwave.core.classes.DefaultPathScannerClassLoaderRetrieverForClassHunter
class-hunter.new-isolated-path-scanner-class-loader.search-config.check-file-option=\
	$&#123;hunters.default-search-config.check-file-option&#125;
class-path-helper.class-path-hunter.search-config.check-file-option=\
	$&#123;hunters.default-search-config.check-file-option&#125;
class-hunter.default-path-scanner-class-loader=\
	(Supplier&lt;PathScannerClassLoader>)() -> ((ComponentSupplier)parameter[0]).getPathScannerClassLoader()
class-path-hunter.default-path-scanner-class-loader=\
	(Supplier&lt;PathScannerClassLoader>)() -> ((ComponentSupplier)parameter[0]).getPathScannerClassLoader()
#This variable is empty by default and can be valorized by developer and it is
#included by 'class-path-hunter.default-path-scanner-class-loader.supplier.imports' property
class-path-hunter.default-path-scanner-class-loader.supplier.additional-imports=
class-path-hunter.default-path-scanner-class-loader.supplier.imports=\
	$&#123;code-executor.common.imports&#125;;\
	$&#123;class-path-hunter.default-path-scanner-class-loader.supplier.additional-imports&#125;;\
	org.burningwave.core.classes.PathScannerClassLoader;
class-path-hunter.default-path-scanner-class-loader.supplier.name=\
	org.burningwave.core.classes.DefaultPathScannerClassLoaderRetrieverForClassPathHunter
class-path-hunter.new-isolated-path-scanner-class-loader.search-config.check-file-option=\
	$&#123;hunters.default-search-config.check-file-option&#125;
#This variable is empty by default and can be valorized by developer and it is
#included by 'code-executor.common.import' property
code-executor.common.additional-imports=
code-executor.common.imports=\
	static org.burningwave.core.assembler.StaticComponentContainer.BackgroundExecutor;\
	$&#123;code-executor.common.additional-imports&#125;;\
	org.burningwave.core.assembler.ComponentSupplier;\
	java.util.function.Function;\
	org.burningwave.core.io.FileSystemItem;\
	org.burningwave.core.io.PathHelper;\
	org.burningwave.core.concurrent.QueuedTasksExecutor$ProducerTask;\
	org.burningwave.core.concurrent.QueuedTasksExecutor$Task;\
	java.util.function.Supplier;
component-container.after-init.operations.imports=\
	$&#123;code-executor.common.imports&#125;;\
	$&#123;component-container.after-init.operations.additional-imports&#125;;\
	org.burningwave.core.classes.SearchResult;
component-container.after-init.operations.executor.name=\
	org.burningwave.core.assembler.AfterInitOperations
hunters.default-search-config.check-file-option=\
	$&#123;path-scanner-class-loader.search-config.check-file-option&#125;
path-scanner-class-loader.parent=\
	Thread.currentThread().getContextClassLoader()
#This variable is empty by default and can be valorized by developer and it is
#included by 'path-scanner-class-loader.parent.supplier.imports' property
path-scanner-class-loader.parent.supplier.additional-imports=\
path-scanner-class-loader.parent.supplier.imports=\
	$&#123;code-executor.common.imports&#125;;\
	$&#123;path-scanner-class-loader.parent.supplier.additional-imports&#125;;
path-scanner-class-loader.parent.supplier.name=\
	org.burningwave.core.classes.ParentClassLoaderRetrieverForPathScannerClassLoader
#other possible values are: checkFileName, checkFileName|checkFileSignature, checkFileName&amp;checkFileSignature
path-scanner-class-loader.search-config.check-file-option=checkFileName
#This variable is empty by default and can be valorized by developer and it is
#included by 'paths.class-factory.default-class-loader.class-repositories' property
paths.class-factory.default-class-loader.additional-class-repositories=
#this variable indicates all the paths from which the classes 
#must be taken if during the definition of the compiled classes
#on classloader there will be classes not found
paths.class-factory.default-class-loader.class-repositories=\
	$&#123;paths.java-memory-compiler.class-paths&#125;;\
	$&#123;paths.java-memory-compiler.class-repositories&#125;;\
	$&#123;paths.class-factory.default-class-loader.additional-class-repositories&#125;
paths.hunters.default-search-config.paths=\
	$&#123;paths.main-class-paths&#125;;\
	$&#123;paths.main-class-paths.extension&#125;;\
	$&#123;paths.main-class-repositories&#125;;
#This variable is empty by default and can be valorized by developer and it is
#included by 'paths.java-memory-compiler.class-paths' property
paths.java-memory-compiler.additional-class-paths=
paths.java-memory-compiler.black-listed-class-paths=\
	//$&#123;paths.main-class-paths&#125;/..//children:.*?surefirebooter\d&#123;0,&#125;\.jar;
#this variable indicates all the class paths used by the JavaMemoryCompiler
#component for compiling
paths.java-memory-compiler.class-paths=\
	$&#123;paths.main-class-paths&#125;;\
	$&#123;paths.main-class-paths.extension&#125;;\
	$&#123;paths.java-memory-compiler.additional-class-paths&#125;
#This variable is empty by default and can be valorized by developer. and it is
#included by 'paths.java-memory-compiler.class-repositories' property
paths.java-memory-compiler.additional-class-repositories=
#All paths inserted here will be analyzed by JavaMemoryCompiler component in case 
#of compilation failure to search for class paths of all classes imported by sources 
paths.java-memory-compiler.class-repositories=\
	$&#123;paths.main-class-repositories&#125;;\
	$&#123;paths.java-memory-compiler.additional-class-repositories&#125;;
paths.main-class-paths=\
	$&#123;system.properties:java.class.path&#125;
paths.main-class-paths.extension=\
	//$&#123;system.properties:java.home&#125;/lib//children:.*?\.jar;\
	//$&#123;system.properties:java.home&#125;/lib/ext//children:.*?\.jar;\
	//$&#123;system.properties:java.home&#125;/../lib//children:.*?\.jar;
paths.main-class-repositories=\
	//$&#123;system.properties:java.home&#125;/jmods//children:.*?\.jmod;
#mandatory if more burningwave.properties file are in the class paths
priority-of-this-configuration=0</pre>



<p class="has-text-align-left"><strong>If in your custom burningwave.properties file one of this default properties is not found, the relative default value here in the box above is assumed</strong>.    </p>



<p class="has-text-align-left">If you create a component container instance through method ComponentContainer.create(String relativeConfigFileName), you can specify the file name of your properties file and you can locate it everywhere in your classpath project but remember to use a relative path in this case, i.e.: if you name your file &#8220;custom-config-file.properties&#8221; and put it in package &#8220;org.burningwave&#8221; you must create the component container as follow:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">ComponentContainer.create("org/burningwave/custom-config-file.properties")</pre>



<p class="has-text-align-left"><a href="https://github.com/burningwave/core/blob/master/src/test/resources/burningwave.properties#L1">Here an example of a&nbsp;<strong>burningwave.properties</strong>&nbsp;file</a>.</p>



<p></p>
</div>