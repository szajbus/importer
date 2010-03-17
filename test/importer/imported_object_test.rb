require 'helper'

class Importer::ImportedObjectTest < Test::Unit::TestCase
  context "given an import" do
    setup { @import = Factory(:import) }

    context "creating a new imported object" do
      setup { Factory(:imported_object, :import => @import, :state => "new_object") }

      should_change("import's new_objects_count", :by => 1) { @import.reload.new_objects_count }
    end

    context "with an imported object" do
      setup { @imported_object = Factory(:imported_object, :import => @import, :state => "new_object") }

      context "destroying the imported object" do
        setup { @imported_object.destroy }

        should_change("import's new_objects_count", :by => -1) { @import.reload.new_objects_count }
      end
    end
  end

  context "creating new imported object" do
    setup { @imported_object = Factory(:imported_object, :data => { "a" => "b" }) }

    should "serialize it's data" do
      data = { "a" => "b" }
      assert_equal data, @imported_object.data
    end
  end
end
