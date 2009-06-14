	
	#use map.album in your main routes.rb to enable these routes
	
module ConceptAlbum #:nodoc:  
	module Routing #:nodoc:  
		module MapperExtensions 
			def album
				@set.add_route('concept_album_asset/:path', {:controller => 'albums', 
																										 :action => 'serve_asset', 
																						         :path => /.*.(js|css|jpg|gif|png|swf)/})
				@set.add_route('concept_album/random', {:controller => 'albums', :action => 'random'})
				@set.add_route('concept_album/random_markup/:number', {:controller => 'albums', :action => 'random_markup'})
				@set.add_route('concept_album/slideshow_feed.xml', {:controller => 'albums', :action => 'slideshow_feed'})
				@set.add_route('concept_album/size_for', {:controller => 'albums', 
																									:action => 'get_slideshow_size_for_viewport'})  
				@set.add_route('concept_album/*path', {:controller => 'albums', :action => 'show'})
						    
			end
		end  
	end
end

ActionController::Routing::RouteSet::Mapper.send :include, ConceptAlbum::Routing::MapperExtensions 
