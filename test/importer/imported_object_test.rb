require 'helper'

class Importer::ImportedObjectTest < Test::Unit::TestCase
  context "creating a new imported object" do
    setup do
      @data = { 'a' => 'b' }
      @validation_errors = { 'c' => 'd' }
      @imported_object = Importer::ImportedObject.new(:state => 'existing_object', :object => 'DummyObject', :data => @data, :validation_errors => @validation_errors)
    end

    should "correctly set it's attributes" do
      assert_equal 'existing_object', @imported_object.state
      assert_equal 'DummyObject', @imported_object.object
      assert_equal @data, @imported_object.data
      assert_equal @validation_errors, @imported_object.validation_errors
    end
  end
end