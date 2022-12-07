<%@page contentType="text/html;charset=UTF-8" language="java" %>
<div class="container">

	<div class="row">

		<div class="col-md-12">

			<div class="content">
			
						
			<div id="post-1765" class="post-1765 page type-page status-publish has-post-thumbnail hentry">
			
			     <h1 class="entry-title">Performing tasks in parallel with different priorities in Java</h1>
			    
			     <div class="entry">

			       
<div class="wp-block-columns has-2-columns w-two-one-use-case">
<div class="wp-block-column">
<p>Used by the <strong>IterableObjectHelper</strong> to  <a href="/iterating-collections-and-arrays-in-parallel/">iterate collections or arrays in parallel</a>, the <strong>BackgroundExecutor</strong> component is able to run different functional interfaces in parallel <strong>by setting the priority of the thread they will be assigned to</strong>. There is also the option to wait for them start or finish. To use this component we must add to our <em>pom.xml</em> the following dependency:</p>

<%@include file="burningwave-core-import.jsp"%>

<p>For obtaining threads this component uses the <a name="ThreadSupplier"><strong>ThreadSupplier</strong></a> that can be customized in the <a href="/overview-and-configuration/#configuration-1">burningwave.static.properties</a> file  through the following properties:</p>


<pre class="EnlighterJSRAW" data-enlighter-language="ini" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="false" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">thread-supplier.default-daemon-flag-value=true
thread-supplier.default-thread-priority=5
thread-supplier.max-detached-thread-count=${thread-supplier.max-poolable-thread-count}
thread-supplier.max-detached-thread-count.elapsed-time-threshold-from-last-increase-for-gradual-decreasing-to-initial-value=30000
thread-supplier.max-detached-thread-count.increasing-step=autodetect
thread-supplier.max-poolable-thread-count=autodetect
thread-supplier.poolable-thread-request-timeout=6000</pre>



<p>The ThreadSupplier provides a fixed number of reusable threads indicated by the&nbsp;<strong><code>thread-supplier.max-poolable-thread-count</code></strong>&nbsp;property and, if these threads have already been assigned, new non-reusable threads will be created whose quantity maximum is indicated by the&nbsp;<strong><code>thread-supplier.max-detached-thread-count</code></strong>&nbsp;property. Once this limit is reached if the request for a new thread exceeds the waiting time indicated by the&nbsp;<strong><code>thread-supplier.poolable-thread-request-timeout</code></strong>&nbsp;property, the ThreadSupplier will proceed to increase the limit indicated by the &#8216;thread-supplier.max-detached-thread-count&#8217; property for the quantity indicated by the&nbsp;<strong><code>thread-supplier.max-detached-thread-count.increasing-step</code></strong>&nbsp;property. Resetting the &#8216;thread-supplier.max-detached-thread-count&#8217; property to its initial value, will occur gradually only when there have been no more waits on thread requests for an amount of time indicated by the&nbsp;<strong><code>thread-supplier.max-detached-thread-count.elapsed-time-threshold-from-last-increase-for-gradual-decreasing-to-initial-value</code></strong>&nbsp;property. </p>



<pre class="EnlighterJSRAW" data-enlighter-language="java" data-enlighter-theme="" data-enlighter-highlight="" data-enlighter-linenumbers="" data-enlighter-lineoffset="" data-enlighter-title="" data-enlighter-group="">import static org.burningwave.core.assembler.StaticComponentContainer.BackgroundExecutor;

import org.burningwave.core.ManagedLogger;
import org.burningwave.core.concurrent.QueuedTasksExecutor.ProducerTask;
import org.burningwave.core.concurrent.QueuedTasksExecutor.Task;


public class TaskLauncher implements ManagedLogger {
    
    public void launch() {
        ProducerTask&lt;Long> taskOne = BackgroundExecutor.createProducerTask(task -> {
            Long startTime = System.currentTimeMillis();
            logInfo("task one started");
            synchronized (this) {                
                wait(5000);
            }
            Task internalTask = BackgroundExecutor.createTask(tsk -> {
                logInfo("internal task started");    
                synchronized (this) {                
                    wait(5000);
                }
                logInfo("internal task finished");    
            }, Thread.MAX_PRIORITY).submit();
            internalTask.waitForFinish();
            logInfo("task one finished");
            return startTime;
        }, Thread.MAX_PRIORITY);
        taskOne.submit();
        Task taskTwo = BackgroundExecutor.createTask(task -> {
            logInfo("task two started and wait for task one finishing");
            taskOne.waitForFinish();
            logInfo("task two finished");    
        }, Thread.NORM_PRIORITY);
        taskTwo.submit();
        ProducerTask&lt;Long> taskThree = BackgroundExecutor.createProducerTask(task -> {
            logInfo("task three started and wait for task two finishing");
            taskTwo.waitForFinish();
            logInfo("task two finished");
            return System.currentTimeMillis();
        }, Thread.MIN_PRIORITY);
        taskThree.submit();
        taskThree.waitForFinish();
        logInfo("Elapsed time: {}ms", taskThree.join() - taskOne.join());
    }
    
    public static void main(String[] args) {
        new TaskLauncher().launch();
    }
    
}</pre>
</div>



<div class="wp-block-column">

<div replace="/right-menu.html" />


<p></p>
</div>
</div>
			     </div>

			     
			 </div>
			
			 
			 			

			</div>

		</div>

		

	</div>

</div>