require File.dirname(__FILE__) + '/test_helper.rb' 
require 'albums_controller' 
require 'action_controller/test_process' 
class AlbumsController; def rescue_action(e) raise e end; end 
class AlbumsControllerTest < Test::Unit::TestCase 
	def setup 
		@controller = AlbumsController.new
		@request = ActionController::TestRequest.new
		@response = ActionController::TestResponse.new 
		ActionController::Routing::Routes.draw do |map| 
			map.album   
		end  
	end
	#not sure how to test plugin without relying on rails root environment.rb  
	def test_show_image
		#get :show, :path => 'photo1.jpg'
		#assert_response :success 
	end 
end 
