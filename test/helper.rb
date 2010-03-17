require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'importer'

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.establish_connection(config['test'])

require 'factory_girl'
require 'factories'

class Test::Unit::TestCase
  def setup
    reset_tables
  end

  def reset_tables
    ActiveRecord::Base.connection.create_table :products, { :force => true } do |t|
      t.string  :customid
      t.string  :name
      t.string  :description
      t.decimal :price
    end

    ActiveRecord::Base.connection.create_table :imports, { :force => true } do |t|
      t.integer :new_objects_count,       :default => 0
      t.integer :existing_objects_count,  :default => 0
      t.integer :invalid_objects_count,   :default => 0
    end

    ActiveRecord::Base.connection.create_table :imported_objects, { :force => true } do |t|
      t.integer :import_id
      t.string  :object_type
      t.integer :object_id
      t.string  :data
      t.string  :state
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