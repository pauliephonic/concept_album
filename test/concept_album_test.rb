require File.dirname(__FILE__) + '/test_helper.rb' 

class ConceptAlbumTest < ActiveSupport::TestCase
	
  def test_all_libraries_present
  	#check we can use all required libraries
  	i = Magick::ImageList.new
  	assert_kind_of Magick::ImageList, i
  end

end
