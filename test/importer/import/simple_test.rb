require 'helper'

class Importer::Import::SimpleTest < Test::Unit::TestCase
  context "" do
    setup do
      @product = Factory(:product, :customid => "1", :name => "A pink ball", :description => "Round glass ball.", :price => 86)
    end

    context "importing from an XML file" do
      setup do
        @import = Product.import(fixture_file("products.xml"), :import => Factory(:simple_import))
      end

      should "create one new product" do
        assert_equal 1, @import.new_objects_count
      end

      should "modify one existing product" do
        assert_equal 1, @import.existing_objects_count
      end

      should "not save one product because of errors" do
        assert_equal 1, @import.invalid_objects_count
      end
    end
  end

  context "an import" do
    setup { @import = Factory(:simple_import) }

    should "correctly build imported object" do
      imported_object = @import.build_imported_object
      assert_equal @import, imported_object.import
    end
  end
end