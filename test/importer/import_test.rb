require 'helper'

class Importer::ImportTest < Test::Unit::TestCase
  def setup
    @import = Importer::Import.new
  end

  context "when sent #build_imported_object" do
    setup do
      @imported_object = @import.build_imported_object
    end

    should "correctly return instance of Importer::ImportedObject" do
      assert @imported_object.is_a?(Importer::ImportedObject)
    end
  end

  context "import with some imported_object" do
    setup do
      @new_object      = Importer::ImportedObject.new(:state => 'new_object')
      @existing_object = Importer::ImportedObject.new(:state => 'existing_object')
      @invalid_object  = Importer::ImportedObject.new(:state => 'invalid_object')

      @import.add_object(@new_object)
      @import.add_object(@existing_object)
      @import.add_object(@invalid_object)
    end

    should "correctly return all imported objects" do
      assert_same_elements [@new_object, @existing_object, @invalid_object], @import.imported_objects
    end

    should "correctly return new_imported_objects" do
      assert_same_elements [@new_object], @import.new_imported_objects
    end

    should "correctly return existing_imported_objects" do
      assert_same_elements [@existing_object], @import.existing_imported_objects
    end

    should "correctly return invalid_imported_objects" do
      assert_same_elements [@invalid_object], @import.invalid_imported_objects
    end
  end
end
