require 'helper'

class Importer::ImportedObject::ActiveRecordTest < Test::Unit::TestCase
  context "given an import" do
    setup { @import = Factory(:active_record_import) }

    context "creating a new imported object" do
      setup { Factory(:active_record_imported_object, :import => @import, :state => "new_object") }

      should_change("import's new_objects_count", :by => 1) { @import.reload.new_objects_count }
    end

    context "with an imported object" do
      setup { @imported_object = Factory(:active_record_imported_object, :import => @import, :state => "new_object") }

      context "destroying the imported object" do
        setup { @imported_object.destroy }

        should_change("import's new_objects_count", :by => -1) { @import.reload.new_objects_count }
      end
    end
  end

  context "creating new imported object" do
    setup { @imported_object = Factory(:active_record_imported_object, :data => { "a" => "b" }, :validation_errors => { "c" => "d" }) }

    should "serialize it's data" do
      data = { "a" => "b" }
      assert_equal data, @imported_object.data
    end

    should "serialize it's validation errors" do
      validation_errors = { "c" => "d" }
      assert_equal validation_errors, @imported_object.validation_errors
    end
  end
end
