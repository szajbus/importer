require 'helper'

class Importer::ImportedObject::SimpleTest < Test::Unit::TestCase
  context "given an import" do
    setup { @import = Factory(:simple_import) }

    context "creating a new imported object" do
      setup do
        imported_object       = Importer::ImportedObject::Simple.new(:import => @import)
        imported_object.state = "new_object"
        imported_object.save
      end

      should_change("import's new_objects_count", :by => 1) { @import.new_objects_count }
    end

    context "creating new imported object" do
      setup do
        @imported_object                   = Importer::ImportedObject::Simple.new(:import => @import)
        @imported_object.data              = { "a" => "b" }
        @imported_object.validation_errors = { "c" => "d" }
      end

      should "correctly set/get data" do
        data = { "a" => "b" }
        assert_equal data, @imported_object.data
      end

      should "correctly set/get validation errors" do
        validation_errors = { "c" => "d" }
        assert_equal validation_errors, @imported_object.validation_errors
      end
    end
  end
end
