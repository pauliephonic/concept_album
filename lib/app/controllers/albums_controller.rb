class AlbumsController < ApplicationController
  # GET /concept_album/
  # GET /concept_album/album.xml
	layout 'concept_album'
  def index
    @base_album = Album.base
    respond_to do |format|
      format.html
      format.xml  { render :xml => @base_album }
    end
  end

  # GET /concept_album/path/to/album
  # GET /concept_album/path/to/album.xml
  # GET /concept_album/path/to/album/image.jpg
  def show
    @path_items = params[:path]
    @path = "/" + @path_items.join('/')
    puts "doing show #{@path.inspect}"
    if /(?:jpg|gif|png|jpeg)$/i =~ @path
	  	image = Image.from_url(@path)
	  	if params[:resize]
	  		image.set_size params[:resize]
			else
				image.set_size :large
	  	end
	  	if params[:resize_mode]
	  		image.resize_mode = params[:resize_mode]
	  	end
	  	send_image_if_exists image
	  elsif /\.xml$/i =~ @path 
	  	path = @path.gsub(/\.xml$/,'')
			@album = album_from_cache_or_path(path)
	  	render :xml => @album
	  else
			@album = album_from_cache_or_path(@path)
			@current_page = (params[:page] || 1).to_i
    end
  end

  # GET /concept_album/random?number=9&layout=false
  def random
		number = (params[:number] || 9).to_i
		opts = {}
		params[:layout] == 'false' ? do_layout = false : do_layout = true
		@images = Album.base.random_images(number)
		render :action => 'random_grid', :layout => do_layout
  end
  
  # GET /concept_album/slideshow_feed.xml
  def slideshow_feed
		number = (params[:number] || 15).to_i
		@images = Album.base.random_images(number)
		respond_to do |format|
			format.xml {render :layout => false}
		end
  end
  
  def random_markup
		number = (params[:number] || 9).to_i
		@images = Album.base.random_images(number)
		render :partial => 'inline_random', :locals => {:images => @images}
  end
  
  def get_slideshow_size_for_viewport
  	width = params[:width].to_i - 60
  	height = params[:height].to_i - 60
		required_size = Album.nearest_named_size_below(width, height)
  	new_width, new_height = ConceptAlbum::Config.named_size_dimensions[required_size]	
  	render :json => {:name => required_size, :width => new_width, :height => new_height}.to_json
  end
  
  
  def serve_asset
    path = params[:path]
    if /\.js$/i =~ path
    	send_file(asset_path(path), {:disposition => 'inline',
  						 :x_sendfile => true, :type => 'text/javascript'})
 		elsif /\.css$/i =~ path
 			send_file(asset_path(path), {:disposition => 'inline',
  						 :x_sendfile => true, :type => 'text/css'})
  	elsif /\.png$/i =~ path
 			send_file(asset_path(path), {:disposition => 'inline',
  						 :x_sendfile => true, :type => 'image/png'})
  	elsif /\.jpg$/i =~ path
 			send_file(asset_path(path), {:disposition => 'inline',
  						 :x_sendfile => true, :type => 'image/jpeg'})
  	elsif /\.swf$/i =~ path
 			send_file(asset_path(path), {:disposition => 'inline',
  						 :x_sendfile => true, :type => 'application/x-shockwave-flash'})
  	elsif /\.gif$/i =~ path
 			send_file(asset_path(path), {:disposition => 'inline',
  						 :x_sendfile => true, :type => 'image/gif'})
 		end
  end
  
  #=====================================================================
  
  
  
  private
  
  def send_image(path, options = {})
  	options = {:disposition => 'inline',
  						 :x_sendfile => true, 
  						 :type => 'image/jpeg', 
  						 :stream => false}.merge(options)
  	expires_in 10.years
		send_file(path, options)	  
	end
	
	def send_image_if_exists(image, options ={})
		image.generate_resized_image unless File.exist? image.cache_file_name
		send_image(image.cache_file_name, options)
	end

	def random_direction_for_crossslide
		#eg  from: 'top left', to: 'bottom right'
		i = rand(4)
		case i
		when 0
			"from: 'top left', to: 'bottom right', "
		when 1
			"from: 'top right', to: 'bottom left', "
		when 2
			"from: 'bottom left', to: 'top right', "
		else
			"from: 'bottom right', to: 'top left', "
		end
	end
	
	def album_from_cache_or_path(path)
		Rails.cache.fetch('album_' + path, :expires_in => 5.minutes) do
		  Album.from_path(path)
		end
	end
	
	def asset_path(file)
		@this_file_path ||= File.dirname(__FILE__)
		File.expand_path(File.join(@this_file_path,'../views/assets',file))
	end

end

