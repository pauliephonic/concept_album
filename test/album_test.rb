require File.dirname(__FILE__) + '/test_helper.rb' 
class AlbumTest < Test::Unit::TestCase
	do_setup_config
	
	def test_album_model_is_available
		assert_kind_of Album, Album.new
	end
	
	def test_base_folder_can_be_read
		a = Album.base
	end
	
	def test_root_url
		
	end
end 
