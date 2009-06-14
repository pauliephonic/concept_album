	function createSlideshowMarkup(div_name, width, height, num_images){
		if (typeof SWFObject=="undefined") {
			document.write('<script type="text/javascript" src="/concept_album_asset/swfobject.js"></script>');
		}
		document.write('<script type="text/javascript">doFlashSlideshow(\'' + div_name + '\',' +  width + ',' +  height + ',' +  num_images + ');</script>');
	}
	
	function doFlashSlideshow(div_name, width, height, num_images){
		var so = new SWFObject("/concept_album_asset/minislideshow.swf", "minislideshow", width, height, "9.0.115.0", "ffffff");
		var src = '/concept_album/slideshow_feed.xml?number=' + num_images
		so.addParam("flashVars","xmlUrl=" + src + " &delay=7&shuffle=false&showDropShadow=true&transOutType=Fade&transInType=Fade&showTitle=false&showControls=false");
		so.addParam("wmode","transparent");
		so.addParam("allowFullscreen","true");
		so.addParam("allowScriptAccess","always");
		so.write(div_name);		
	}

