# desc "Explaining what the task does"
# task :concept_album do
#   # Task goes here
# end
namespace :concept_album do  
	namespace :thumbs do  
		description =  "Scan current album from base and make sure a thumnail has been "  
		description << "generated for all"  
		
		desc description 
		task :pregen_thumbs do  
			 size = ENV['size'] || 'thumb'
			 #get all images from root
			 #open each set size and call generate thumb
			 
		end  
	end 
end 
