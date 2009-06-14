module AlbumsHelper
	
	def contents_description(album)
		ret = []
		ret << "#{album.sub_albums.length} sub-albums" if album.sub_albums.length > 0
		ret << "#{album.images.length} images" if album.images.length > 0
		ret = ret.join(' and ')
		if ret != ''
			ret = "Album contains " + ret + '.'
		else
			ret = "This album is empty."
		end
		ret
	end
	
	def title_link(album)
		if album.path == '/'
			ConceptAlbum::Config.site_name
		else
			link_to ConceptAlbum::Config.site_name, '/concept_album'
		end
	end
	
	def crumb_trail(path_items)
		ret = ""
		path = "/concept_album"
		items_except_last(path_items).each do |folder|
			path = File.join(path, folder)
			ret << "#{link_to nice_name(folder), path} &gt; \n"
		end
		ret << "#{nice_name(path_items.last)} \n" unless path_items.empty?
		ret = "&gt; " + ret unless ret == ''
	end
	
	def paging_nav(total_items, current_item, album_url)
	  ret =""
		(1..@album.total_pages).each do |page|
			if page == @current_page
				contents = page.to_s
			else
				contents = page_link(page, album_url)
			end
		  ret << "<span class=\"page_nav\">#{contents}</span>\n"
		end
		ret
	end
	
	def page_link(page, album_url)
		"<a href=\"#{page_url(page, album_url)}\">#{page}</a>\n"
	end
	
	def page_url(page, album_url)
		url = File.join("/concept_album", album_url)
		url + '?page=' + page.to_s
	end
	
	def nice_name(folder)
		folder.gsub! '_',' '
		folder.split.collect{|w| w.capitalize}.join(' ')
	end
	
	def items_except_last(array)
		array[0..-2]
	end
	
	def slideshow_markup(album)
		#generate a crossfade slideshow
		#with script etc
	end
	
	def nice_xml_url(url)
		url.gsub '&', '&amp;'
	end
	
	def random_grid_markup(number)
		images = Album.base.random_images(number)
		render :partial => 'albums/inline_random', :locals => {:images => images}
	end
end
