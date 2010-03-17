module Importer
  class Import < ::ActiveRecord::Base
    has_many :imported_objects, :class_name => "Importer::ImportedObject"
  end
end
