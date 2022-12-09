<div class="wp-block-column">
<p>Through&nbsp;<strong>FileSystemItem</strong>&nbsp;you can reach a resource of the file system even if it is contained in a nested supported (<strong>zip, jar, war, ear, jmod</strong>) compressed archive and obtain the content of it or other informations such as if it is a folder or a file or a compressed archive or if it is a compressed entry or obtain, if it is a folder or a compressed archive, the direct children or all nested children or a filtered collection of them. To start we need to add the following dependency to our&nbsp;<em>pom.xml</em>:</p>


<%@include file="common/burningwave-core-import.jsp"%>


<p>Let’s take look at the code now: :</p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">package org.burningwave.core.examples.filesystemitem;

import org.burningwave.core.assembler.ComponentContainer;
import org.burningwave.core.io.FileSystemItem;

public class ResourceReacher {
    
    private static void execute() {
        //Obtaining FileSystemItem through absolute path
        FileSystemItem fSI = FileSystemItem.ofPath("C:/Program Files (x86)");
       
        
        FileSystemItem firstFolderFound = null;
        
        //Obtaining direct children
        for (FileSystemItem child : fSI.getChildren()) {
            System.out.println("child name:" + child.getAbsolutePath());
            if (firstFolderFound == null &amp;&amp; child.isFolder()) {
                 System.out.println(child.getAbsolutePath() + " is a folder: " + child.isFolder());
                 firstFolderFound = child;
            }
        }
        
        //Filtering all nested children for extension
        for (FileSystemItem child : firstFolderFound.findInAllChildren(
            FileSystemItem.Criteria.forAllFileThat(fSIC -> 
                "txt".equals(fSIC.getExtension()) || "exe".equals(fSIC.getExtension()))
            )
        ){
            System.out.println("child name: " + child.getName() + " - child parent: " + child.getParent().getName());
            //copy the file to a folder
            child.copyTo(System.getProperty("user.home") + "/Desktop/copy");
        }
        
        //Obtaining a FileSystemItem through a relative path (in this case we are obtaining a reference to a jar
        //contained in an ear that is contained in a zip
        fSI = ComponentContainer.getInstance().getPathHelper().getResource(
            "/../../src/test/external-resources/libs-for-test.zip/ESC-Lib.ear/APP-INF/lib/jaxb-xjc-2.1.7.jar"
        );
        
        System.out.println("is an archive:" + fSI.isArchive());
        
        //This method return true if the file or folder is located inside a compressed archive
        System.out.println("is compressed:" + fSI.isCompressed());
        
        //this clear cache
        fSI.refresh(true);
        
        //Obtaining direct children
        for (FileSystemItem child : fSI.getChildren()) {
            System.out.println("child name:" + child.getAbsolutePath());
        }
        
        //Obtaining all nested children
        for (FileSystemItem child : fSI.getAllChildren()) {
            System.out.println("child name:" + child.getAbsolutePath());
        }
        
        //Obtaining the content of the resource (once the content is loaded it will be cached)
        fSI.toByteBuffer();
    }
    
    public static void main(String[] args) {
        execute();
    }
    
}</pre>



<p>As you can see in the box above, you can retrieve a FileSystemItem through an absolute path or through a relative path referred to your classpath by using the PathHelper. FileSystemItems are cached and&nbsp;<strong>there will only be one instance of them for an absolute path</strong>&nbsp;and you can also clear the cache e reload all informations of a FileSystemItem. In the example below we show how to retrieve and use a FileSystemItem. </p>
</div>