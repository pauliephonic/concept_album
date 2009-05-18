require File.dirname(__FILE__) + '/test_helper.rb' 
class AlbumTest < Test::Unit::TestCase
	do_setup_config
	
	def setup
		@a = Album.base
	end
	
	def test_album_model_is_available
		assert_kind_of Album, Album.new
	end
	
	def test_base_folder_can_be_read
		assert_equal 1, @a.images.length, "base album should have 1 image"
		assert_equal 2, @a.sub_albums.length, "base album should have 2 sub-folders"
		assert_equal '/', @a.path, "path of base album should be '/'"
	end
	
end 
