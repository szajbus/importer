##
# Use Bundler
require 'rubygems' if RUBY_VERSION < '1.9'
require 'bundler/setup'

require 'shoulda'
require 'rr'
require 'active_record'
require 'mongo_mapper'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'dm-aggregates'
require 'dm-transactions'

##
# Load importer
require 'importer'

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.establish_connection(config['test'])
DataMapper.setup(:default, config['test'])

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'importer-test'

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit

  # return path to a fixture file from test/fixtures dir
  def fixture_file(file)
    File.expand_path(File.dirname(__FILE__) + "/fixtures/#{file}")
  end
end

def def_class(class_name, parent_class = Object, &blk)
  undef_class(class_name)
  klass = Object.const_set(class_name, Class.new(parent_class))
  klass.module_eval(&blk)
  klass
end

def undef_class(class_name)
  Object.send(:remove_const, class_name) rescue nil
end