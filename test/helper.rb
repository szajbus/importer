require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rr'
require 'active_record'
require 'mongo_mapper'
require 'dm-core'
require 'dm-validations'
require 'dm-aggregates'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'importer'

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.establish_connection(config['test'])
DataMapper.setup(:default, config['test'])

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'importer-test'

class Test::Unit::TestCase
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