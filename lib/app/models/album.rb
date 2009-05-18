		
	class Album
		include ActsLikeAR
		include ConceptAlbum
		
		attr_accessor  :path, :images, :parent, :sub_albums, :thumbnail

		def initialize
			@images = []
			@sub_albums = []
		end
		
		def self.base
				Album.from_path '/'
		end
		
		def self.from_path(local_path)
			Album.create(:path => local_path).scan
		end
		
		def self.from_full_path(full_path)
			local_path = url_from_path(full_path)
			self.from_path local_path
		end
		
		def full_path
			@full_path ||= path_from_url(self.path)
		end
		
		def public_url
			File.join('/concept_album/', self.path)
		end
		
		def slideshow_url
			File.join('/concept_album/slideshow/' ,self.path)
		end
		
		def name
			self.nice_folder_name
		end
		
		def nice_folder_name
			if self.path == '/'
				ret = "Base Album"
			else
				#last part of path fixed
				ret = File.split(self.path)[1]
				ret.gsub! '_',' '
				ret.split.collect{|w| w.capitalize}.join(' ')
			end
			ret
		end
		
		def images
			scan unless @scanned
			@images
		end
		
		def sub_albums
			scan unless @scanned
			@sub_albums
		end
		
		def scan
			@images = []
			@sub_albums = []
			Dir.foreach(self.full_path){|f|
				new_file = File.join(self.full_path, f)
				if File.directory?(new_file) && !(DIRPAT =~ f) 
					@sub_albums << Album.from_full_path(new_file)
				else
					if /jpg$/i =~ f && !(/^\./ =~ f) #ignore hidden
						img = Image.from_file_name(new_file)
						@images << img
					end
				end
			}
			@scanned = true
			self
		end
		
		def for_xml
			{:name => self.name,
			 :url => self.url, 
			 :sub_albums => self.sub_albums.map{|a| a.for_xml}, 
			 :images => self.images.map{|i| i.for_xml}
			}
		end
		
		def to_xml
			self.for_xml.to_xml
		end
		
		def all_child_photos
			ret =  self.images.dup
			self.sub_albums.each{|s|
				s.all_child_photos.each{|i|
					ret << i
				}
			}
			ret
		end
		
		def random_images(num)
		  list = all_child_photos
		  results = []
		  until list.empty? || results.length == num
		    pos = (rand * list.length).to_i
		    results << list[pos]
		    list.delete_at pos
		  end
		  results
		end
	end
