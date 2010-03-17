require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'factory_girl'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'importer'

require 'active_record'
config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.establish_connection(config['test'])

require 'factories'

class Test::Unit::TestCase
  def setup
    reset_table
  end

  def reset_table
    ActiveRecord::Base.connection.create_table :products, { :force => true } do |t|
      t.string  :customid
      t.string  :name
      t.string  :description
      t.decimal :price
    end
  end

  # return path to a fixture file from test/fixtures dir
  def fixture_file(file)
    File.expand_path(File.dirname(__FILE__) + "/fixtures/#{file}")
  end
end

class Product < ActiveRecord::Base
  include Importer

  validates_numericality_of :price

  def self.find_on_import(attributes)
    find_by_customid(attributes["customid"])
  end
end