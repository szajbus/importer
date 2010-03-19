require 'helper'

class Importer::Parser::XmlTest < Test::Unit::TestCase
  context "parsing an XML file with many objects defined" do
    setup { @data = Importer::Parser::Xml.run(fixture_file("products.xml")) }

    should "detect all objects" do
      product1 = {
        "customid"    => "1",
        "name"        => "A black ball",
        "description" => "Round glass ball.",
        "price"       => "86.00"
      }

      product2 = {
        "customid"    => "2",
        "name"        => "A red hat",
        "description" => "Party hat.",
        "price"       => "114.00"
      }

      product3 = {
        "customid"    => "3",
        "name"        => "A white ribbon",
        "description" => "A really long one.",
        "price"       => "oops"
      }

      assert @data.include?(product1)
      assert @data.include?(product2)
      assert @data.include?(product3)
      assert_equal 3, @data.size
    end
  end

  context "parsing an XML file with one object defined" do
    setup { @data = Importer::Parser::Xml.run(fixture_file("product.xml")) }

    should "detect one object" do
      product1 = {
        "customid"    => "1",
        "name"        => "A black ball",
        "description" => "Round glass ball.",
        "price"       => "86.00"
      }

      assert_equal [product1], @data
    end
  end

  context "parsing an XML file with no objects defined" do
    setup { @data = Importer::Parser::Xml.run(fixture_file("empty.xml")) }

    should "detect no objects" do
      assert_equal [], @data
    end
  end
end
