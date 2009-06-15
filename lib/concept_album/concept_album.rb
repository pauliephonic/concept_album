
	module ConceptAlbum
		DIRPAT = /(^\.|^\.\.)/
				
		def base_album_path
			ConceptAlbum::Config.base_album_path
		end
		
		def cache_path 
			# config full path if set or Rails root & 
			ConceptAlbum::Config.cache_path || File.join(RAILS_ROOT, 'public/concept_album')
		end
			
		def path_from_url(url)
			File.join(base_album_path, url)
		end
		
		def cache_path_from_url(url)
			File.join(cache_path, url)
		end
		
		def base_album_folder
			path_from_url('')
		end
		
		def url_from_path(path)
			File.join('/', path.gsub(base_album_path,''))
		end
		
		def bounds_from_string(string)
			string.downcase.split('x').map{|s| s.to_i}
		end
		
		def nearest_named_size_below(width, height)
			ratio = width.to_f / height
			max_name = :thumb #default if nothing found
			if ratio > 4/3.0  #we will be limited by width
				puts "wider than long"
				max_width = 0
				ConceptAlbum::Config.named_size_dimensions.each{|name,dims|
					named_size_width = dims[0]
					named_size_height = dims[1]
					if named_size_width <= width && named_size_height <= height  #below? 
						if  named_size_width > max_width #larger than found so far
							max_width = named_size_width
							max_name = name
						end
					end
				}
			else
				max_height = 0
				ConceptAlbum::Config.named_size_dimensions.each{|name,dims|
					named_size_width = dims[0]
					named_size_height = dims[1]
					if named_size_height <= height && named_size_width <= width #below? 
						if named_size_height > max_height #larger than found so far
							max_height = named_size_height
							max_name = name
						end
					end
				}
			end
			max_name
		end
		
		def size_of(named_size)
				ConceptAlbum::Config.named_size_dimensions[named_size]
		end
				
		module ClassMethods; end
	
		def self.included(klass)
			klass.extend(ClassMethods)
			klass.extend(ConceptAlbum)
		end
			
		module ClassMethods
			
		end
		
		class Config
			#only size required are thumbs
			@@named_sizes = {:tiny => '60x60' , :thumb_square => '100x100',   :thumb => '120x90', 
			                 :small => '400x300',  :medium => '640x480', :large => '800x600', 
			                 :extra_large => '1024x768', :feckin_massive => '1152x864'}
			                 
			@@max_width = 1200
			@@max_height = 900
			@@cache_path = nil
			def self.max_width
				@@max_width
			end
			def self.max_height
				@@max_height
			end
			def self.base_album_path
				@@album_relative_path ||= 'photos'
			end
			
			def self.base_album_path=(path)
				@@album_relative_path = path
			end
			
			#cache path is relative to rails root
			def self.cache_path 
				@@cache_path 
			end
			
			def self.cache_path=(path)
				@@cache_path = path
			end
			
			def self.images_per_page
				@@images_per_page ||= 35
			end
			
			def self.images_per_page=(num)
				@@images_per_page = num
			end
			
			def self.default_thumbnail
				@@default_thumbnail ||= "100x100"
			end
			
			def self.named_size_dimensions
				result = {}
				@@named_sizes.each{|k,v|
					result[k] = v.strip.downcase.split('x').map{|s| s.to_i}
				}
				result
			end
			def self.set_named_size(name,bounds)
				@@named_sizes[name.to_sym] = bounds
			end
			def self.get_named_size(name)
				@@named_sizes[name.to_sym]
			end
			def self.bounds_for_size(size)
				raise "Unknown Size" unless @@named_sizes.keys.include? size.to_sym
				@@named_sizes[size.to_sym]
			end
			
			def self.named_size_keys
  			@@named_sizes.keys
			end
			
			def self.site_name
				@@site_name ||= 'Metal Album'
			end
			def self.site_name=(site_name)
				@@site_name = site_name
			end
		end
	end
