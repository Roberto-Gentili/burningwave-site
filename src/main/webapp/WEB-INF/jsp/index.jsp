<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<!--[if IE 7]>
<html class="ie ie7" lang="en-GB">
<![endif]-->
<!--[if IE 8]>
<html class="ie ie8" lang="en-GB">
<![endif]-->
<!--[if !(IE 7) | !(IE 8) ]><!-->
<html lang="en-GB">
<!--<![endif]-->
<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
<!-- /Added by HTTrack -->
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="profile" href="https://gmpg.org/xfn/11">
	<link rel="pingback" href="xmlrpc.php">
	
	<jsp:include page="header/${contentPath}.jsp" />
	
	<%@include file="common/header.jsp"%>
	
</head>

<body data-rsssl=1
	class="home page-template page-template-template_home page-template-template_home-php page page-id-234 user-registration-page">

	<nav class="navbar navbar-default navbar-fixed-top" itemscope
		itemtype="http://schema.org/SiteNavigationElement" role="navigation">

		<div class="container-fluid">

			<div class="container">

				<div class="navbar-header">

					<button type="button" class="navbar-toggle" data-toggle="collapse"
						data-target="#navbar-ex-collapse">

						<span class="sr-only">Toggle navigation</span> <span
							class="icon-bar"></span> <span class="icon-bar"></span> <span
							class="icon-bar"></span>

					</button>

					<h1 class="site-title">
						<a href="/" class="navbar-brand"><img
							class="img-responsive"
							src="/wp-content/uploads/2020/04/logo_miglior.jpg"
							alt="Burningwave"></a>
					</h1>
				</div>
				<div replace="/nav-bar.html" />

			</div>

		</div>

	</nav>
	<section id="welcome" class="hero">
		<div class="container">
			<div class="row">
				<div class="col-md-12">
					<h1 id="homePageTitle">Burningwave</h1>
					<h2>
						<b>A set consisting of a Java frameworks building library and
							other applications and frameworks based on it</b>
					</h2>
					<div class="lead text-center">
						<p>
							<i>The main library of Burningwave's software is </i><b><a
								style="color: white;" href="https://burningwave.github.io/core"
								target="_blank">Burningwave Core</a></b><i>, an advanced, free
								and open source Java frameworks building library useful for <a
								style="color: white;"
								href="/how-to-find-all-classes-in-a-package/"
								target="_blank">scanning class paths</a>, <a
								style="color: white;"
								href="/generating-classes-at-runtime-and-invoking-their-methods-with-and-without-the-use-of-reflection/"
								target="_blank">generating classes at runtime</a>, <a
								style="color: white;"
								href="https://burningwave.github.io/core/#Handling-privates-and-all-other-members-of-an-object"
								target="_blank">facilitating the use of reflection</a>, <a
								style="color: white;"
								href="/reaching-a-resource-of-the-file-system/"
								target="_blank">scanning the filesystem</a>, <a
								style="color: white;"
								href="/executing-stringified-source-code/"
								target="_blank">executing stringified source code</a>, <a
								style="color: white;"
								href="/iterating-collections-and-arrays-in-parallel/"
								target="_blank">iterating collections or arrays in parallel</a>,
								<a style="color: white;"
								href="/performing-different-tasks-in-parallel-and-with-different-priorities/"
								target="_blank">executing tasks in parallel</a> and much more,
								Burningwave Core contains <b>AN EXTREMELY POWERFUL CLASSPATH
									SCANNER</b>: it’s possible to search classes by every criteria that
								your imagination can make by using lambda expressions. <b>Scan
									engine is highly optimized using direct allocated ByteBuffers
									to avoid heap saturation; searches are executed in
									multithreading context and are not affected by “the issue of
									the same class loaded by different classloaders”</b> (normally if
								you try to execute "isAssignableFrom" method on a same class
								loaded from different classloader it returns false). So let's...
							</i>
						</p>
					</div>
					<div class="col-md-6 text-right">
						<a href="/get-started/" class="btn btn-lg btn-secondary">Get
							Started</a>
					</div>
					<div class="col-md-6 text-left">
						<a href="https://search.maven.org/search?q=g:org.burningwave"
							class="btn btn-lg btn-primary">Download</a>
					</div>
				</div>
			</div>
		</div>
	</section>
		<section id="work" class="work lite ">
			<div class="container">
				<style>
					#wpsm_counter_b_row_2137 .wpsm_counterbox {
						text-align: center;
						margin-top: 40px;
						margin-bottom: 10px;
					}
					
					#wpsm_counter_b_row_2137 .wpsm_counterbox .wpsm_count-icon {
						display: block;
						margin-top: 20px;
						padding-top: 0px;
						padding-bottom: 0px;
						margin-bottom: 0px;
						margin: 0 auto;
					}
					
					#wpsm_counter_b_row_2137 .wpsm_counterbox .wpsm_count-icon i {
						font-size: 15px;
						color: #ff531d;
					}
					
					#wpsm_counter_b_row_2137 .wpsm_counterbox .wpsm_number {
						font-size: 18px;
						font-weight: 500;
						color: #f7bc12;
						font-family: 'Open Sans';
						letter-spacing: 2px;
						margin-top: 20px;
						line-height: 1.3em;
						padding-top: 0px;
						padding-bottom: 0px;
						margin-bottom: 0px;
					}
					
					#wpsm_counter_b_row_2137 .wpsm_counterbox .wpsm_count-title {
						font-size: 15px;
						font-weight: bolder;
						font-family: 'Open Sans';
						letter-spacing: 2px;
						color: ff531d;
						font-weight: 500;
						margin-top: 20px;
						padding-top: 0px;
						padding-bottom: 0px;
						margin-bottom: 0px;
						line-height: 1.3em;
					}
				</style>
				<style>
					#wpsm_counter_b_row_2137 {
						position: relative;
						width: 100%;
						overflow: hidden;
						text-align: center;
					}
					
					#wpsm_counter_b_row_2137 .wpsm_row {
						overflow: hidden;
						display: block;
						width: 100%;
					}
					
					#wpsm_counter_b_row_2137 .wpsm_row {
						overflow: visible;
					}
					
					#wpsm_counter_b_row_2137 .wpsm_counterbox .wpsm_count-title {
						min-height: 56px;
					}
				</style>

				<div class="wpsm_counter_b_row" id="wpsm_counter_b_row_2137">
					<div>
						<a id="bw-counters" href="#bw-counters">&nbsp;</a>
			
						<div class="wpsm_row">
			
							<div class="wpsm_col-md-4 wpsm_col-sm-6">
								<div class="wpsm_counterbox">
			
									<div class="wpsm_count-icon">
										<i #ff531d class="fa fa-arrow-down"></i>
									</div>
									<div class="wpsm_number" style="">
										<a style="color: unset;"
											href="/stats/artifact-download-chart?groupId=org.burningwave&groupId=com.github.burningwave">
											<span class="counter" id="counterId0">&nbsp;</span></a>*
										<script type="text/javascript"
											src="/wp-content/plugins/counter-number-showcase/assets/js/counter_nscript.js"></script>
										<script>
											setupCounter(
				                                'counterId0',
				                                '${basePath}/miscellaneous-services/stats/total-downloads?groupId=org.burningwave&groupId=com.github.burningwave',
				                                900000,
				                                0,
				                                2000
			                                );
				                        </script>
									</div>
									<h3 class="wpsm_count-title" ff531d>Artifact downloads from
										Maven Central (monthly update)</h3>
								</div>
							</div>
						</div>
						<div class="wpsm_row">
							<div class="wpsm_col-md-4 wpsm_col-sm-6">
								<div class="wpsm_counterbox">
			
									<div class="wpsm_count-icon">
										<i #ff531d class="fa fa-star-o"></i>
									</div>
									<div class="wpsm_number" style="">
										<a style="color: unset;" href="https://github.com/burningwave">
											<span class="counter" id="counterId1">&nbsp;</span></a>*
										<script type="text/javascript"
											src="/wp-content/plugins/counter-number-showcase/assets/js/counter_nscript.js"></script>
										<script>
				                			setupCounter(
				                                'counterId1',
				                                '${basePath}/miscellaneous-services/stats/star-count?' + 
			                               			'repository=burningwave:core&' +
			                               			'repository=burningwave:jvm-driver&' +
			                               			'repository=burningwave:tools&' +
			                               			'repository=burningwave:reflection&' +
			                               			'repository=burningwave:graph&' +
			                               			'repository=burningwave:miscellaneous-services',
				                                900000,
				                                0,
				                                2000
											);
			                      			</script>
									</div>
									<h3 class="wpsm_count-title" ff531d>GitHub stars (daily update)</h3>
								</div>
							</div>
							<div class="wpsm_col-md-4 wpsm_col-sm-6">
								<div class="wpsm_counterbox">
			
									<div class="wpsm_count-icon">
										<i #ff531d class="fa fa-laptop"></i>
									</div>
									<div class="wpsm_number" style="">
										<span class="counter" id="counterId2">&nbsp;</span>
										<script type="text/javascript"
											src="/wp-content/plugins/counter-number-showcase/assets/js/counter_nscript.js"></script>
										<script>
											setupCounter(
				                                'counterId2',
				                                '${basePath}/miscellaneous-services/stats/visited-pages-counter',
				                                30000,
				                                0,
				                                2000
			                                );
				                        </script>
									</div>
									<h3 class="wpsm_count-title" ff531d>Pages visited</h3>
			
								</div>
							</div>
			
						</div>
					</div>
				</div>

				<div style="background: #e54d1d;">
					<hr>
				</div>
				<div class="row">
					<div class="col-md-12 heading"></div>
					<div class="col-md-12"></div>
				</div>
			</div>
		</section>


		<%@include file="common/footer.jsp"%>

		<script type="text/javascript">
			jQuery(document).ready(function($){
			$('#testimonials').parallax("50%", 0.4); 	 $('#calltoaction').parallax("50%", 0.4); 	 $('#newsletter').parallax("50%", 0.4); 
			$('.flexslider').flexslider({
			animation: "slide",
			slideshow: true,
			slideshowSpeed: parseInt(7)*1000,
			});
		
			$('.testislider').flexslider({
			controlNav: true, 
			animation: "slide",
			slideshow: true,
			slideshowSpeed: parseInt(7)*1000,
			});
		})	
		</script>
		<script type='text/javascript'
			src='wp-content/plugins/contact-form-7/includes/js/scriptsb62d.js?ver=5.1.6'></script>
		<script type='text/javascript'
			src='wp-content/plugins/counter-number-showcase/assets/js/bootstrap8217.js?ver=5.3.14'></script>
		<script type='text/javascript'
			src='wp-content/plugins/counter-number-showcase/assets/js/counter_nscript8217.js?ver=5.3.14'></script>
		<script type='text/javascript'
			src='wp-content/plugins/counter-number-showcase/assets/js/waypoints.min8217.js?ver=5.3.14'></script>
		<script type='text/javascript'
			src='wp-content/plugins/counter-number-showcase/assets/js/jquery.counterup.min8217.js?ver=5.3.14'></script>
		<script type='text/javascript'
			src='wp-includes/js/jquery/ui/effect.mine899.js?ver=1.11.4'></script>
		<script type='text/javascript'
			src='wp-content/themes/integral/js/parallaxc358.js?ver=1.1.3'></script>
		<script type='text/javascript'
			src='wp-content/themes/integral/js/bootstrap.min7984.js?ver=3.3.4'></script>
		<script type='text/javascript'
			src='wp-content/themes/integral/js/jquery.prettyPhoto005e.js?ver=3.1.6'></script>
		<script type='text/javascript'
			src='wp-content/themes/integral/js/jquery.flexslider-min72e6.js?ver=2.6.4'></script>
		<script type='text/javascript'
			src='wp-content/themes/integral/js/smooth-scroll5152.js?ver=1.0'></script>
		<script type='text/javascript'
			src='wp-content/plugins/enlighter/resources/enlighterjs/enlighterjs.min2f54.js?ver=4.1'></script>
		<script type='text/javascript'>
		!function(n,o){"undefined"!=typeof EnlighterJS?(n.EnlighterJSINIT=function(){EnlighterJS.init("pre.EnlighterJSRAW", "code.EnlighterJSRAW", {"indent":4,"ampersandCleanup":true,"linehover":true,"rawcodeDbclick":true,"textOverflow":"scroll","linenumbers":true,"theme":"classic","language":"generic","retainCssClasses":false,"collapse":false,"toolbarOuter":"","toolbarTop":"{BTN_RAW}{BTN_COPY}{BTN_WINDOW}{BTN_WEBSITE}","toolbarBottom":""})})():(o&&(o.error||o.log)||function(){})("Error: EnlighterJS resources not loaded yet!")}(window,console);
		</script>
		<script type='text/javascript' src='wp-includes/js/wp-embed.min8217.js?ver=5.3.14'></script>

	</body>

</html>
<script type='text/javascript' src='/js/includeOrReplace.js'></script>
<script type="text/javascript">
	showMessages();
</script>