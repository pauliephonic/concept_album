ConceptAlbum
============
Concept Album is a zero administration Rails photo album plugin with an attractive minimal design.

I have a version running on my site [here](http://www.plopcentral.com/concept_album)

The random slideshow control can be viewed on the right of my blog [here](http://www.plopcentral.com/)

Features
========
 - Zero administration, just dump files and folders into the album folder.
 - Clean minimal album design with little visual distraction and large thumbnails.
 - Liquid layout; thumbnails flow to fill up the space. Looks particularly good on a widescreen displays.
 - On the fly resizing and caching
 - Lightbox built-in.
 - Smart preview displays images to suit the size of the viewers browser.
   e.g. small versions of photos are sent to a netbook, full-size to a 24" Display
 - Unobtrusive slideshow effect by simply 'remote controlling' the Lightbox plugin.
 - Optional flash slideshow component to add to your site
 - No database required
 - Requires little configuration
   - Install Plugin
   - Point it to photos in environment.rb
   - Navigate to the url /concept_album and you have a full working photo album!
   - Routes are handled by the plugin, assets are served by the plugin
  

Requirements
============
 - RMagick (and therefore imagemagick)


Installation
============
script/plugin install  git://github.com/pauliephonic/concept_album.git

RMagick
-------
Rmagick can be fun to get installed, you'll need the imagemagick libraries installed on your box. 

Google is your friend.

Test that Rmagick and the plugin are working
============================================

navigate to the vendor/plugins/concept_album folder and run rake to test the installation

(Note my test helper is failing on rails 2.3.2 with a missing Constant I need to fix the helper to work in 2.2 on)


Configuration of the album for your site
========================================

Add the following:

 - Routes.rb
    - add 'map.album' to top of routes.rb
 - environment.rb (add to bottom)
    - ConceptAlbum::Config.site_name = 'Your Album Name'
    - ConceptAlbum::Config.base_album_path = '/home/user/site_photos' #full path to album base
    - require 'RMagick'
 
Ensure that cache path e.g. /public/concept_album is writable by the railsprocess

Retart your site

Navigate to /concept_album in your site, you should have a fully working photo album


Including album content in your sites pages
===========================================

To include your album images within other pages in your application 

There are 2 methods:

Use the helper 

    <%= random\_grid\_markup(number)%> 

in your view. This will add random images to your page, you will need to have included the following in your layout

    jquery.lightbox-0.5.css, jquery-1.3.2.js, jquery.lightbox-0.5.js   

Use the slideshow javascript 

     <script src="/concept_album_asset/flash_slideshow.js" type="text/javascript"></script>
     <div style="width:220px" id="flash_slideshow"></div>
     <script type="text/javascript">createSlideshowMarkup('flash_slideshow',220,165,20);</script>

This requires no additional files

Tips
====
I just synchronise a folder on my computer with a folder on my server using Rsync and the folders photos show up in the album automagically. The site takes care of thumbnailing and resizing itself.

Don't copy 12 Megabyte images into the album folder if you are worried about performance, resizing these will take much CPU. Try using smaller version of the files. I use 1280x1024 versions of my photos



Copyright (c) 2009 Paul McConnon, released under the MIT license



