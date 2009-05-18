require File.dirname(__FILE__) + '/test_helper.rb' 
class ImageTest < Test::Unit::TestCase
	do_setup_config
	def test_image_model_is_available
		assert_kind_of Image, Image.new
	end
	
	
end 
