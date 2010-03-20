require 'helper'

class Importer::ImportedObjectTest < Test::Unit::TestCase
  should "return ActiveRecord imported object for ActiveRecord import" do
    import = Factory(:active_record_import)
    assert_equal Importer::ImportedObject::ActiveRecord, Importer::ImportedObject.get_klass(import)
  end
end