class AlbumsController < ApplicationController
  # GET /concept_album/
  # GET /concept_album/album.xml
	
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
    end
  end

  # GET /concept_album/random?number=9&mode=slideshow&layout=false&size=thumb
  def random
		number = (params[:number] || 9).to_i
		opts = {}
		opts[:layout] = (params[:layout] != 'false') 
		@images = Album.base.random_images(number)
		render 'random_grid', opts
  end
  
  def get_slideshow_size_for_viewport
  	width = params[:width].to_i - 60
  	height = params[:height].to_i - 60
		required_size = Album.nearest_named_size_below(width, height)
  	new_width, new_height = ConceptAlbum::Config.named_size_dimensions[required_size]	
  	render :json => {:name => required_size, :width => new_width, :height => new_height}.to_json
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
	 
end

