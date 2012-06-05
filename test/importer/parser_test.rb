require 'helper'

class Importer::ParserTest < ActiveSupport::TestCase
  should "return Xml parser for file with .xml extension" do
    assert_equal Importer::Parser::Xml, Importer::Parser.get_klass("file.xml")
  end

  should "raise exception if no parser can be found for file" do
    assert_raises Importer::ParserNotFoundError do
      Importer::Parser.get_klass("file.unknown")
    end
  end
end