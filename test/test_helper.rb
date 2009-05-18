require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'test/unit'

ENV['RAILS_ENV'] = 'test' 
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..' 
#require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

require File.dirname(__FILE__) + '/../rails/init.rb'

def do_setup_config
	ConceptAlbum::Config.site_name = 'PhotoTest'
	ConceptAlbum::Config.base_album_path = File.expand_path(File.join( File.dirname(__FILE__), 'test_album_structure'))
	ConceptAlbum::Config.cache_path = File.expand_path(File.join(File.dirname(__FILE__), 'test_cache_folder'))
	require 'RMagick'
end 
