  function doLightbox(div_name){
  	jQuery("#" + div_name + " a").lightBox();
  }
	function doRandomMarkup(number, div_name){
		if (typeof div_name == 'undefined' || div_name == ''){
			div_name = 'random_image_holder';
		}
		do_lightbox = false;
		if (typeof jQuery == 'undefined'){
			document.write('<script type="text/javascript" src="/concept_album_asset/jquery-1.3.2.js"></script>');
			document.write('<script type="text/javascript">jQuery.noConflict();</script>');
			do_lightbox = true;
		}
		if (do_lightbox || (typeof jQuery.fn.lightBox == 'undefined')) {
			document.write('<link href="/concept_album_asset/jquery.lightbox-0.5.css" media="screen" rel="stylesheet" type="text/css" />');
			document.write('<script type="text/javascript" src="/concept_album_asset/jquery.lightbox-0.5.js"></script>');
		}
		//create the div for writing to
		document.write('<div id="' + div_name + '"></div>');
		document.write('<script type="text/javascript">jQuery(function(){jQuery("#' + div_name + '").load("/concept_album/random_markup/' + number + '","", function(){ doLightbox("' + div_name + '");});});</script>');
		//document.write('<script type="text/javascript">jQuery(function(){jQuery("#concept_image_holder a").lightBox();});</script>');
	}

