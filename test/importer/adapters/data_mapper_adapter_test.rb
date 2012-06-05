require 'helper'

class Importer::Adapters::DataMapperAdapterTest < ActiveSupport::TestCase
  setup do
    def_class("Product") do
      include DataMapper::Resource
      include Importer

      property :id,           DataMapper::Property::Serial
      property :customid,     String
      property :name,         String
      property :description,  String
      property :price,        Float

      validates_numericality_of :price

      def self.find_on_import(import, attributes)
        first(:customid => attributes["customid"])
      end
    end

    DataMapper.finalize
    DataMapper.auto_migrate!
  end

  teardown do
    undef_class("Product")
  end

  context "" do
    setup do
      @product = Product.create(:customid => "1", :name => "A pink ball", :description => "Round glass ball.", :price => 86)
    end

    context "importing objects" do
      setup do
        @new_object      = { "name" => "A red hat", "customid"=>"2", "price" => "114.00", "description" => "Party hat." }
        @existing_object = { "name" => "A black ball", "customid"=>"1", "price" => "86.00", "description" => "Round glass ball." }
        @invalid_object  = { "name" => "A white ribbon", "customid"=>"3", "price" => "oops", "description" => "A really long one." }

        data = [ @new_object, @existing_object, @invalid_object ]

        stub(Importer::Parser::Xml).run(fixture_file("products.xml")) { data }

        @import = Product.import(fixture_file("products.xml"))
      end

      should "correctly update existing product" do
        assert_equal "A black ball", @product.reload.name
      end

      should "correctly create new product" do
        product = Product.last

        assert_equal "A red hat", product.name
        assert_equal "Party hat.", product.description
        assert_equal 114, product.price
        assert_equal "2", product.customid
      end

      should "correctly summarize the import process" do
        assert_equal 1, @import.new_imported_objects.size
        assert_equal 1, @import.existing_imported_objects.size
        assert_equal 1, @import.invalid_imported_objects.size
      end

      should "correctly build imported objects" do
        new_object      = @import.new_imported_objects.first
        existing_object = @import.existing_imported_objects.first
        invalid_object  = @import.invalid_imported_objects.first

        assert_equal @new_object,       new_object.data
        assert_equal 'new_object',      new_object.state
        assert_equal Product.last,      new_object.object

        assert_equal @existing_object,  existing_object.data
        assert_equal 'existing_object', existing_object.state
        assert_equal @product,          existing_object.object

        assert_equal @invalid_object,   invalid_object.data
        assert_equal 'invalid_object',  invalid_object.state
        assert_equal ["Price must be a number"], invalid_object.validation_errors
      end
    end

    context "when there is exception during import process" do
      setup do
        def_class("InvalidProduct", Product) do
          storage_names[:default] = "products"

          def self.find_on_import(import, attributes)
            if attributes["customid"] == "3"
              raise ::Exception.new("An error occured.")
            else
              super
            end
          end
        end

        DataMapper.finalize

        begin
          InvalidProduct.import(fixture_file("products.xml"))
        rescue ::Exception => e
          @exception = e
        end

        @count = InvalidProduct.count
      end

      teardown do
        undef_class("InvalidProduct")
      end

      should "not update exising product" do
        assert_equal "A pink ball", @product.reload.name
      end

      should "not create new products" do
        assert_equal @count, InvalidProduct.count
      end

      should "propagate exception" do
        assert_equal "An error occured.", @exception.message
      end
    end
  end

  context "passing import_options to #import method" do
    setup do
      stub(Importer::Parser::Xml).run(fixture_file("empty.xml")) { [] }

      @options = { :key => 'value' }
      @import = Product.import(fixture_file("empty.xml"), :import_options => @options)
    end

    should "pass the options to Import instance" do
      assert_equal @options, @import.options
    end
  end
end
