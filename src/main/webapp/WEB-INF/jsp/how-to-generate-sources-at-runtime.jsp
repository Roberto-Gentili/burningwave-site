<div class="wp-block-column">
<p>With&nbsp;<strong>UnitSourceGenerator</strong>&nbsp;you can generate source code and store it on the drive.  first of all, we must add to our pom.xml the following dependency:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Assuming this class as example:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package source.generation.test;

import java.util.Arrays;
import java.util.List;

public class GeneratedClass {
    
    
    private List&lt;String> words;
    
    public GeneratedClass(String... words) {
        this.words = Arrays.asList(words);
    }
    
    public void print() {
        System.out.print(String.join(" ", words));
    }
    
    public static void main(String[] args) {
        new GeneratedClass(args).print();
    }
}</pre>



<p>&#8230; The relative code to generate and store it will be:</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package source.generation.test;

import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.List;

import org.burningwave.core.classes.ClassSourceGenerator;
import org.burningwave.core.classes.FunctionSourceGenerator;
import org.burningwave.core.classes.GenericSourceGenerator;
import org.burningwave.core.classes.TypeDeclarationSourceGenerator;
import org.burningwave.core.classes.UnitSourceGenerator;
import org.burningwave.core.classes.VariableSourceGenerator;

public class SourceGenerationTester {

    
    public static UnitSourceGenerator generate() {
        return UnitSourceGenerator.create(SourceGenerationTester.class.getPackage().getName())
        .addClass(
            ClassSourceGenerator.create(TypeDeclarationSourceGenerator.create("GeneratedClass"))
            .addField(
                VariableSourceGenerator.create(
                    TypeDeclarationSourceGenerator.create(List.class)
                    .addGeneric(GenericSourceGenerator.create(String.class)),
                    "words"
                )
            )
            .addConstructor(
                FunctionSourceGenerator.create().addParameter(
                    VariableSourceGenerator.create(
                        TypeDeclarationSourceGenerator.create(String.class)
                        .setAsVarArgs(true),
                        "words"
                    )
                ).addBodyCodeLine("this.words = Arrays.asList(words);").useType(Arrays.class)
            )
            .addMethod(
                FunctionSourceGenerator.create("print")
                .addModifier(Modifier.PUBLIC).setReturnType(void.class)
                .addBodyCodeLine(
                  "System.out.println(\"\\n\\t\" + String.join(\" \", words) + \"\\n\");"
                )
            )
            .addMethod(
                FunctionSourceGenerator.create("main")
                .addModifier(Modifier.PUBLIC | Modifier.STATIC)
                .setReturnType(void.class)
                .addParameter(VariableSourceGenerator.create(String[].class, "args"))
                .addBodyCodeLine("new GeneratedClass(args).print();")
            )
        );
    }
    
    
    public static void main(String[] args) {
        UnitSourceGenerator unitSG = SourceGenerationTester.generate();
        unitSG.storeToClassPath(System.getProperty("user.home") + "/Desktop/sources");
        System.out.println("\nGenerated code:\n" + unitSG);
        
    }
}</pre>



<p>Once the sources have been generated <strong>you can also compile them at runtime</strong>: to do this follow <strong><a href="../how-to-compile-sources-at-runtime/index.html">this guide</a></strong>.</p>
</div>