require 'helper'

class ImporterTest < Test::Unit::TestCase
  context "given an existing product" do
    setup do
      @product = Factory(:product, :customid => "1", :name => "A pink ball", :description => "Round glass ball.", :price => 86)
    end

    context "importing from an XML file" do
      setup do
        Product.import(fixture_file("products.xml"))
      end

      should_change("product's name", :from => "A pink ball", :to => "A black ball") { @product.reload.name }

      should_change("products count", :by => 1) { Product.count }
      should "correctly create new product" do
        product = Product.last

        assert_equal "A red hat", product.name
        assert_equal "Party hat.", product.description
        assert_equal 114, product.price
        assert_equal "2", product.customid
      end
    end
  end
end
