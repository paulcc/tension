# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'


## xapian stuff
#

desc "config the xapian search"
task :mk_xapian do          
  system 'rake xapian:rebuild_index  models="Extension"'
  system 'rake xapian:update_index'
  system 'rake xapian:query models="Extension" query="extension"'
end


