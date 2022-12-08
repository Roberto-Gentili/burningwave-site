<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<!-- Mirrored from www.burningwave.org/performing-different-tasks-in-parallel-and-with-different-priorities/ by HTTrack Website Copier/3.x [XR&CO'2014], Sun, 04 Dec 2022 08:39:45 GMT -->
<!-- Added by HTTrack --><meta http-equiv="content-type" content="text/html;charset=UTF-8" /><!-- /Added by HTTrack -->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="profile" href="https://gmpg.org/xfn/11">
    <link rel="pingback" href="xmlrpc.php">
	
	<jsp:include page="${contentPath}.header.jsp" />
	
	<%@include file="common-header.jsp"%>
	
</head>

<body data-rsssl=1 class="page-template-default page page-id-1765 user-registration-page">
    
        <nav class="navbar navbar-default navbar-fixed-top" itemscope itemtype="http://schema.org/SiteNavigationElement" role="navigation">

            <div class="container-fluid">

                <div class="container">

                    <div class="navbar-header">

                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-ex-collapse">

                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>

                        </button>

                        <h1 class="site-title"><a href="/" class="navbar-brand"><img class="img-responsive" src="/wp-content/uploads/2020/04/logo_miglior.jpg" alt="Burningwave"></a></h1>
                    </div>
                    
                        <div replace="/nav-bar.html"/>
                    
               </div>

            </div>

        </nav>
<div class="spacer"></div>

<div class="container">
	<div class="row">
		<div class="col-md-12">
			<div class="content">
				<div class="page type-page status-publish has-post-thumbnail hentry">
					<c:if test="${empty sectionTitle">
					    <h1 class="entry-title">${sectionTitle}</h1>
					</c:if>
					<div class="entry">
						<c:choose>
  							<c:when test="${empty rightMenuDisabled}">
	  							<div class="wp-block-columns has-2-columns w-two-one-use-case">
									<jsp:include page="${contentPath}.jsp" />
									<div class="wp-block-column">
										<div replace="/right-menu.html" />
										<p></p>
									</div>
								</div>
  							</c:when>
  							<c:otherwise>
  								<jsp:include page="${contentPath}.jsp" />
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


	<section id="features" class="features lite ">
			<div class="container">
				<div class="row multi-columns-row">
											<div class="col-sm-4 col-md-4 col-lg-4"><div class="feature"><i class="fa fa-lightbulb-o pull-left featureicon"></i><h4>Flexible</h4><p>It’s possible to search classes by every criteria that your imagination can make by using lambda expressions</p>
</div></div><div class="col-sm-4 col-md-4 col-lg-4"><div class="feature"><i class="fa fa-database pull-left featureicon"></i><h4>Optimized</h4><p>Scan engine is highly optimized using direct allocated ByteBuffers to avoid heap saturation</p>
</div></div><div class="col-sm-4 col-md-4 col-lg-4"><div class="feature"><i class="fa fa-unlock pull-left featureicon"></i><h4>Open</h4><p>Burningwave core is an advanced free and open source Java library</p>
</div></div>									</div>
			</div>
		</section>

        <section class="copyright">

            <div class="container">

                <div class="row">

                    <div class="col-md-12">

                        <div class="copyrightinfo">

                            <p>
                                
                                &copy;2020 Burningwave - All Rights Reserved
                                                            </p>

                        </div>

                    </div>

                </div>

            </div>

        </section>

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
        
<div id="fb-root"></div>
<script type='text/javascript'>
/* <![CDATA[ */
var wpcf7 = {"apiSettings":{"root":"https:\/\/www.burningwave.org\/wp-json\/contact-form-7\/v1","namespace":"contact-form-7\/v1"},"cached":"1"};
/* ]]> */
</script>
<script type='text/javascript' src='/wp-content/plugins/contact-form-7/includes/js/scriptsb62d.js?ver=5.1.6'></script>
<script type='text/javascript' src='/wp-content/plugins/counter-number-showcase/assets/js/bootstrap8217.js?ver=5.3.14'></script>
<script type='text/javascript' src='/wp-content/plugins/counter-number-showcase/assets/js/counter_nscript8217.js?ver=5.3.14'></script>
<script type='text/javascript' src='/wp-content/plugins/counter-number-showcase/assets/js/waypoints.min8217.js?ver=5.3.14'></script>
<script type='text/javascript' src='/wp-content/plugins/counter-number-showcase/assets/js/jquery.counterup.min8217.js?ver=5.3.14'></script>
<script type='text/javascript' src='/wp-content/plugins/ultimate-blocks/src/blocks/content-toggle/front.build3601.js?ver=2.2.0'></script>
<script type='text/javascript' src='/wp-includes/js/jquery/ui/effect.mine899.js?ver=1.11.4'></script>
<script type='text/javascript' src='/wp-content/themes/integral/js/parallaxc358.js?ver=1.1.3'></script>
<script type='text/javascript' src='/wp-content/themes/integral/js/bootstrap.min7984.js?ver=3.3.4'></script>
<script type='text/javascript' src='/wp-content/themes/integral/js/jquery.prettyPhoto005e.js?ver=3.1.6'></script>
<script type='text/javascript' src='/wp-content/themes/integral/js/jquery.flexslider-min72e6.js?ver=2.6.4'></script>
<script type='text/javascript' src='/wp-content/plugins/enlighter/resources/enlighterjs/enlighterjs.min2f54.js?ver=4.1'></script>
<script type='text/javascript'>
!function(n,o){"undefined"!=typeof EnlighterJS?(n.EnlighterJSINIT=function(){EnlighterJS.init("pre.EnlighterJSRAW", "code.EnlighterJSRAW", {"indent":4,"ampersandCleanup":true,"linehover":true,"rawcodeDbclick":true,"textOverflow":"scroll","linenumbers":true,"theme":"classic","language":"generic","retainCssClasses":false,"collapse":false,"toolbarOuter":"","toolbarTop":"{BTN_RAW}{BTN_COPY}{BTN_WINDOW}{BTN_WEBSITE}","toolbarBottom":""})})():(o&&(o.error||o.log)||function(){})("Error: EnlighterJS resources not loaded yet!")}(window,console);
</script>
<script type='text/javascript' src='/wp-includes/js/wp-embed.min8217.js?ver=5.3.14'></script>
    
    </body>


</html>
<script type='text/javascript' src='/js/includeOrReplace.js'></script>