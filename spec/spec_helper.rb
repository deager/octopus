$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
MIGRATIONS_ROOT = File.expand_path(File.join(File.dirname(__FILE__),  'migrations'))
require 'spec'
require 'spec/autorun'
require "database_connection"
require 'octopus'

Spec::Runner.configure do |config|  
  config.before(:each) do
    clean_all_shards()    
  end

  config.after(:each) do
    clean_all_shards()
  end
end

def clean_all_shards()
  ActiveRecord::Base.connection.shards.keys.each do |shard_symbol|
    ActiveRecord::Base.using(shard_symbol).connection.execute("delete from schema_migrations;")
    ActiveRecord::Base.using(shard_symbol).connection.execute("delete from users;")  
    ActiveRecord::Base.using(shard_symbol).connection.execute("delete from clients;")  
  end
end

class Client < ActiveRecord::Base
  sharded_by :country
end