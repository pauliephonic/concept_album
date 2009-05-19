require File.dirname(__FILE__) + '/test_helper.rb' 
class AlbumTest < Test::Unit::TestCase
	do_setup_config
	
	def setup
		@a = Album.base
		@spider_folder = Album.from_path '/Spider'
		@more_folder = Album.from_path '/More_Photos'
	end
	
	def test_album_model_is_available
		assert_kind_of Album, Album.new
	end
	
	def test_base_folder_can_be_read
		assert_equal 1, @a.images.length, "base album should have 1 image"
		assert_equal 2, @a.sub_albums.length, "base album should have 2 sub-folders"
		assert_equal '/', @a.path, "path of base album should be '/'"
	end
	
	def test_public_url
		assert_equal '/concept_album/', @a.public_url
		assert_equal '/concept_album/Spider', @spider_folder.public_url
		assert_equal '/concept_album/More_Photos', @more_folder.public_url
	end
	
	def test_name
		assert_equal 'Base Album', @a.name
		assert_equal 'Spider', @spider_folder.name
		assert_equal 'More Photos', @more_folder.name
	end
	
	def test_format_for_xml
		for_xml = @a.for_xml
		assert_equal 'Base Album', for_xml[:name]
		assert_equal '/concept_album/', for_xml[:url]
		assert_equal 2, for_xml[:sub_albums].length
	end
end 
