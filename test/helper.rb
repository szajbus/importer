require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'importer'

class Test::Unit::TestCase
  # return path to a fixture file from test/fixtures dir
  def fixture_file(file)
    File.expand_path(File.dirname(__FILE__) + "/fixtures/#{file}")
  end
end
