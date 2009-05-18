require File.dirname(__FILE__) + '/test_helper.rb' 

class ConceptAlbumTest < ActiveSupport::TestCase
	def setup
		
	end
  def test_all_libraries_present
  	#check we can use all required libraries
  	i = Magick::ImageList.new
  	assert_kind_of Magick::ImageList, i
  	test = Class.new
  	test.class_eval "include ConceptAlbum"
  	assert_equal test.base_album_path, File.expand_path(File.join( File.dirname(__FILE__), 'test_album_structure'))
  end

end
