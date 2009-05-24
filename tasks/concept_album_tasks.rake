# desc "Explaining what the task does"
# task :concept_album do
#   # Task goes here
# end
namespace :concept_album do  
	namespace :generate_thumbs do  
		description =  "Scan current album from base and make sure a thumnail has been "  
		description << "generated for all"  
		
		desc description 
		task :concept_album => :environment do  
			#do stuff  
		end  
	end 
end 