<div class="wp-block-column">
<p>For this purpose is necessary the use of <strong>ClassFactory</strong> component and of the <strong>sources generating components</strong> but, first of all, we must add to our pom.xml the following dependency:</p>


<%@include file="burningwave-core-import.jsp"%>


<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">requires org.burningwave.core;</pre>



<p>Once the sources have been set in <strong>UnitSourceGenerator</strong> objects, they must be passed to  <strong>loadOrBuildAndDefine </strong>method of ClassFactory with the ClassLoader where you want to define new generated classes. This method performs the following operations: tries to load all the classes present in the UnitSourceGenerator through the class loader, if at least one of these is not found it proceeds to compiling all the UnitSourceGenerators and uploading their classes on class loader: <strong>in this case, keep in mind that if a class with the same name was previously loaded by the class loader, the compiled class will not be uploaded</strong>.  <strong>If you need more information you can</strong>:</p>



<ul style="margin-left: 20px; margin-bottom: 10px; margin-top: 0px;"><li>see a&nbsp;<strong><a href="https://github.com/burningwave/core/blob/master/src/test/java/org/burningwave/core/UnitSourceGeneratorTest.java#L153">complete example about source code generators</a></strong></li><li>read <a href="../forum/topic/how-can-i-use-classes-outside-the-runtime-class-path-in-my-generated-sources/index.html"><strong>this&nbsp;guide</strong></a>&nbsp;where you also can find a link to an&nbsp;<a href="https://github.com/burningwave/core/blob/master/src/test/java/org/burningwave/core/examples/classfactory/ExternalClassRuntimeExtender.java"><strong>example about generating classes by using libraries located outside the runtime class paths</strong></a></li><li>go&nbsp;<a href="https://github.com/burningwave/core/tree/master/src/test/java/org/burningwave/core/examples/classfactory"><strong>here</strong></a>&nbsp;for more examples</li></ul>



<p>Once the classes have been compiled and loaded, it is possible to invoke their methods in severals ways as shown at the end of the example below. </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package org.burningwave.core.examples.classfactory;

import static org.burningwave.core.assembler.StaticComponentContainer.Constructors;

import java.lang.reflect.Modifier;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import org.burningwave.core.Virtual;
import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.assembler.ComponentSupplier;
import org.burningwave.core.classes.AnnotationSourceGenerator;
import org.burningwave.core.classes.ClassFactory;
import org.burningwave.core.classes.ClassSourceGenerator;
import org.burningwave.core.classes.FunctionSourceGenerator;
import org.burningwave.core.classes.GenericSourceGenerator;
import org.burningwave.core.classes.TypeDeclarationSourceGenerator;
import org.burningwave.core.classes.UnitSourceGenerator;
import org.burningwave.core.classes.VariableSourceGenerator;

public class RuntimeClassExtender {

    @SuppressWarnings("resource")
    public static void execute() throws Throwable {
        UnitSourceGenerator unitSG = UnitSourceGenerator.create("packagename").addClass(
            ClassSourceGenerator.create(
                TypeDeclarationSourceGenerator.create("MyExtendedClass")
            ).addModifier(
                Modifier.PUBLIC
            //generating new method that override MyInterface.convert(LocalDateTime)
            ).addMethod(
                FunctionSourceGenerator.create("convert")
                .setReturnType(
                    TypeDeclarationSourceGenerator.create(Comparable.class)
                    .addGeneric(GenericSourceGenerator.create(Date.class))
                ).addParameter(VariableSourceGenerator.create(LocalDateTime.class, "localDateTime"))
                .addModifier(Modifier.PUBLIC)
                .addAnnotation(AnnotationSourceGenerator.create(Override.class))
                .addBodyCodeLine("return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());")
                .useType(ZoneId.class)
            ).addConcretizedType(
                MyInterface.class
            ).expands(ToBeExtended.class)
        );
        System.out.println("\nGenerated code:\n" + unitSG.make());
        //With this we store the generated source to a path
        unitSG.storeToClassPath(System.getProperty("user.home") + "/Desktop/bw-tests");
        ComponentSupplier componentSupplier = ComponentContainer.getInstance();
        ClassFactory classFactory = componentSupplier.getClassFactory();
        //this method compile all compilation units and upload the generated classes to default
        //class loader declared with property "class-factory.default-class-loader" in 
        //burningwave.properties file (see "Overview and configuration").
        //If you need to upload the class to another class loader use
        //loadOrBuildAndDefine(LoadOrBuildAndDefineConfig) method
        ClassFactory.ClassRetriever classRetriever = classFactory.loadOrBuildAndDefine(
            unitSG
        );
        Class&lt;?> generatedClass = classRetriever.get(
            "packagename.MyExtendedClass"
        );
        ToBeExtended generatedClassObject =
            Constructors.newInstanceOf(generatedClass);
        generatedClassObject.printSomeThing();
        System.out.println(
            ((MyInterface)generatedClassObject).convert(LocalDateTime.now()).toString()
        );
        //You can also invoke methods by casting to Virtual (an interface offered by the
        //library for faciliate use of runtime generated classes)
        Virtual virtualObject = (Virtual)generatedClassObject;
        //Invoke by using reflection
        virtualObject.invoke("printSomeThing");
        //Invoke by using MethodHandle
        virtualObject.invokeDirect("printSomeThing");
        System.out.println(
            ((Date)virtualObject.invokeDirect("convert", LocalDateTime.now())).toString()
        );
        classRetriever.close();
    }   

    public static class ToBeExtended {

        public void printSomeThing() {
            System.out.println("Called method printSomeThing");
        }

    }

    public static interface MyInterface {

        public Comparable&lt;Date> convert(LocalDateTime localDateTime);

    }

    public static void main(String[] args) throws Throwable {
        execute();
    }
}</pre>
</div>