require File.dirname(__FILE__) + '/test_helper.rb' 

class ConceptAlbumTest < ActiveSupport::TestCase

  def test_all_libraries_present
  	#check we can use all required libraries
  	i = Magick::ImageList.new
  	assert_kind_of Magick::ImageList, i
  	test = Class.new
  	test.class_eval "include ConceptAlbum"
  	assert_equal test.base_album_path, File.expand_path(File.join( File.dirname(__FILE__), 'test_album_structure'))
  	
  end

	def test_concept_album
		assert_nothing_raised {size = ConceptAlbum::Config.max_width}
	end
	
	def test_default_named_sizes
		assert_equal '60x60' , ConceptAlbum::Config.get_named_size(:tiny)
		assert_equal '100x100' , ConceptAlbum::Config.get_named_size(:thumb_square)
		assert_equal '120x90' , ConceptAlbum::Config.get_named_size(:thumb)
	end
	
	def test_named_size_as_dimension
		dimensions = ConceptAlbum::Config.named_size_dimensions
		
		assert_equal [60,60], dimensions[:tiny]
		assert_equal [100,100], dimensions[:thumb_square]
		assert_equal [120,90], dimensions[:thumb]
		

	end
	
	def test_named_size_set
		assert_equal '60x60' , ConceptAlbum::Config.get_named_size(:tiny)
		ConceptAlbum::Config.set_named_size(:tiny, '70x70')
		assert_equal '70x70' , ConceptAlbum::Config.get_named_size(:tiny)
		assert_equal [70,70] , ConceptAlbum::Config.named_size_dimensions[:tiny] #should be a method, not return hash
		ConceptAlbum::Config.set_named_size(:tiny, '60x60') #set back
	end
	
	def test_nearest_named_size
		#test method when included
		test_class = Class.new
		test_class.extend ConceptAlbum
		assert_equal :thumb_square, test_class.nearest_named_size_below(110,100)
		assert_equal :medium, test_class.nearest_named_size_below(640,480), "Size chosen should allow exact bounds"
		assert_equal :medium, test_class.nearest_named_size_below(640,2080), "Should choose correct nearest size even with large height"
		assert_equal :medium, test_class.nearest_named_size_below(2640,480), "Should choose correct nearest size even with large width"
		assert_equal :medium, test_class.nearest_named_size_below(800,599), "Should choose correct nearest size close to next size up"
		assert_equal :large, test_class.nearest_named_size_below(801,600), "Should choose correct nearest size"
	end
	
	
	
end
