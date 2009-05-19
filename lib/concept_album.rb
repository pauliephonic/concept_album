# ConceptAlbum

require 'concept_album/concept_album'
require "concept_album/routing"

ActionController::Base.view_paths.unshift File.expand_path(File.join(File.dirname(__FILE__),'app', 'views'))

['models','controllers','helpers'].each do |dir| 
	path = File.join(File.dirname(__FILE__), 'app', dir)  
	$LOAD_PATH << path 
	ActiveSupport::Dependencies.load_paths << path 
	ActiveSupport::Dependencies.load_once_paths.delete(path) 
end 
