
  class Image
  	
    include ActsLikeAR
    include ConceptAlbum
    attr_accessor :file_name, :description, :keywords, :parent, :url
    attr_reader   :width, :height, :shutter_speed, :aperture, :iso_speed,
                  :camera_model, :focal_length, :flash 
    
    def initialize
      @description = ''
      @file_name = ''
      @keywords =[]
      @resizing = false
      @bounds_x, @bounds_y = 0,0
      @resize_mode = :fit # can be clip
      @required_size = nil
    end
    
    
    def self.from_url(url)
			match = /^(.*)_resized_(.*)_(clip|fit)(\.jpg)$/i.match(url)
			if match
  			i = Image.create(:url => (match[1] + match[4]))
				i.set_size match[2]
				i.resize_mode = match[3]
			else
				i = Image.create(:url => url)
			end
      i
    end
    
    def self.from_file_name(file_name)
      
      short_path = url_from_path(file_name)
      self.from_url(short_path)
    end
    
    def resize_url
      if @resizing
        File.join('/concept_album/', self.resized_image_url)
      else
        File.join('/concept_album/', self.url)
      end
    end
    
    def for_xml
      {:url => self.url, :description => self.description, :keywords => self.keywords}
    end
  
    def file_name
      path_from_url self.resized_image_path
    end
    
    def cache_file_name
      cache_path_from_url self.resized_image_path
    end
    
    def source_file_name
      path_from_url self.url
    end
    
    def name
      self.nice_name
    end
    
    def parent_album_url
			File.join('/concept_album/', File.split(self.url).first)
    end
    
    def parent_album_name
    	File.split(self.parent_album_url)[1]
    end
    
    def thumbnail_url
      self.new_size_url('thumb_square', 'clip')
    end
    
    def tiny_url
      self.new_size_url('tiny', 'clip')
    end
    
    def new_size_url(size, mode='fit')
      raise "Not a resize mode option" unless [:fit, :clip].include? mode.to_sym
      raise "Not a valid size" unless ConceptAlbum::Config.named_size_keys.include? size.to_sym
      
      #bound_string = ConceptAlbum::Config.get_named_size(size)
      #bounds_x, bounds_y = bounds_from_string(bound_string)
      resized = self.url.gsub(/(\.(?:jpg|png)$)/i, "_resized_#{size}_#{mode}" + '\\1')
      File.join('/concept_album/',resized)
    end
    
    def set_size(size_name) #e.g. :large
      @resizing = true
      @required_size = size_name.to_sym
      new_bounds = ConceptAlbum::Config.bounds_for_size size_name
      @bounds_x, @bounds_y =  bounds_from_string(new_bounds)
    end
    
    def resize_mode=(mode)
      raise "Not an option" unless [:fit, :clip].include? mode.to_sym
      @resize_mode = mode.to_sym
    end
    
    def nice_name
      File.split(self.file_name)[1]
    end
    
    def to_xml
      self.for_xml.to_xml
    end

    def resized_image_path #should be path
      self.url.gsub(/(\.(?:jpg|png)$)/i, "_resized_#{@bounds_x}x#{@bounds_y}_#{@resize_mode}" + '\\1')
    end
        
    ####################################################
    #    resizing image code
    
    def generate_resized_image
      # delete first
      full_image = Magick::ImageList.new(self.source_file_name)
      old_width = full_image.columns
      old_height = full_image.rows
      # TODO use thumbnail method if image much smaller than original
      # as this is faster according to the rmagick docs
      if @resize_mode == :fit
        new_width, new_height = new_size_for_fit(old_width, old_height)
        tiny = full_image.resize(new_width, new_height)
      else
        new_width, new_height = new_size_for_clip(old_width, old_height)
        tiny = full_image.resize(new_width, new_height)
        if @bounds_x < new_width || @bounds_y < new_height
          tiny.crop!(Magick::CenterGravity, @bounds_x, @bounds_y)  
        end
      end
      make_folder_for_file(self.cache_file_name)
      tiny.write self.cache_file_name
      #full_image.destroy!    #not supported by imagemagick < 6.3?
      full_image = nil
			#tiny.destroy!					#not supported by imagemagick < 6.3?
      tiny = nil
      GC.start
    end
    
    def make_folder_for_file(file_name)
      folder = File.split(file_name).first
      FileUtils.mkdir_p folder unless File.exist? folder
    end
    
    def new_size_for_fit(ow, oh)
      #max size limits, retains shape
      nw = ow
      nh = oh
      if nw > @bounds_x
        nh = nh * @bounds_x / nw
        nw = @bounds_x
      end
      if nh > @bounds_y
        nw = nw * @bounds_y / nh
        nh = @bounds_y
      end
      [nw, nh]
    end
    
     def new_size_for_clip(ow, oh)
     	# calc size that will fill bounds, overshooting one dside possibly
			# we can then clip and have scaled to fill size

      # shortest old/new ratio should be max_side
      nw = ow
      nh = oh
      unless ow < @bounds_x || oh < @bounds_y
      	width_ratio = ow / @bounds_x.to_f
	      height_ratio = oh / @bounds_y.to_f
	      if width_ratio > height_ratio
	        nw = nw * (@bounds_y.to_f / oh)
	        nh = @bounds_y
	      else
	        nh = nh * (@bounds_x.to_f / ow)
	        nw = @bounds_x
	      end
      end
      [nw.to_i, nh.to_i]
    end
    
    def pull_exif_data
        image = Magick::ImageList.new(self.source_file_name)
        @width = image.columns
        @height = image.rows
        @shutter_speed = image.get_exif_by_entry("ShutterSpeedValue")[0][1]
        @aperture = image.get_exif_by_entry("ApertureValue")[0][1]
        @iso_speed = image.get_exif_by_entry("ISOSpeedRatings")[0][1]
        @camera_model = image.get_exif_by_entry("Model")[0][1]
        @focal_length = image.get_exif_by_entry("FocalLength")[0][1]
        @flash = image.get_exif_by_entry("Flash")[0][1]
        image = nil
        self
    end
    
  end
