require File.dirname(__FILE__) + '/test_helper.rb' 
class ImageTest < Test::Unit::TestCase
	do_setup_config
	def test_image_model_is_available
		assert_kind_of Image, Image.new
	end
	
	def test_resizing_calculation_fit
		i = Image.new #from_url 'photo1.jpg'
		i.set_size :large #'800x600'
		assert_equal [800,600], i.new_size_for_fit(1600,1200)
		assert_equal [800,300], i.new_size_for_fit(1600,600)
		assert_equal [400,600], i.new_size_for_fit(800,1200)
		assert_equal [100,600], i.new_size_for_fit(200,1200)
		assert_equal [400,300], i.new_size_for_fit(400,300)
		i.set_size :thumb_square
		assert_equal [100,75], i.new_size_for_fit(1600,1200)
		assert_equal [100,37], i.new_size_for_fit(1600,600)
		assert_equal [66,100], i.new_size_for_fit(800,1200)
		assert_equal [16,100], i.new_size_for_fit(200,1200)
	end
	
	def test_resizing_calculation_clip
		#get new size prior to clipping
		i = Image.new
		i.set_size :large #'800x600'
		assert_equal [800,600], i.new_size_for_clip(1600,1200)
		assert_equal [1600,600], i.new_size_for_clip(1600,600)
		assert_equal [1600,500], i.new_size_for_clip(1600,500)

		i.set_size :thumb_square #100x100
		assert_equal [133,100], i.new_size_for_clip(1600,1200)
		assert_equal [800,100], i.new_size_for_clip(1600,200)
		assert_equal [66,120], i.new_size_for_clip(66,120)
		assert_equal [120,66], i.new_size_for_clip(120,66)
		assert_equal [99,66], i.new_size_for_clip(99,66)
	end
	
	def test_resize
		clear_cache_folder
		i = Image.from_url 'photo1.jpg'
		i.pull_exif_data
		#check original dimensions
		assert_equal 1400, i.width
		assert_equal 933,i.height 
		i.set_size :large #'800x600'
		i.generate_resized_image
		
		assert_equal 'photo1_resized_800x600_fit.jpg', i.resized_image_url
		assert File.exist?(i.cache_file_name), "Resized file must exist"
		assert_equal [800,533], get_image_file_size(i.cache_file_name)
	end
	
	def get_image_file_size(file_name)
			image = Magick::ImageList.new(file_name)
      width = image.columns
      height = image.rows
      image = nil
      [width, height]
	end
		
	def clear_cache_folder
		folder = ConceptAlbum::Config.cache_path
		FileUtils.rm_rf File.join folder, 'More_Photos'
		FileUtils.rm_rf File.join folder, 'Spider'
		FileUtils.rm Dir.glob(File.join(folder,'photo1*.jpg'))

	end
end 
