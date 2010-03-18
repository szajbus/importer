require 'active_record'

require 'importer/import'
require 'importer/imported_object'
require 'importer/parser'

module Importer

  class << self
    def included(base)
      base.send(:extend,  Importer::ClassMethods)
    end
  end

  module ClassMethods
    def import(file, options = {})
      import = options[:import] || Importer::Import.create
      parser = options[:parser] || Importer::Parser
      data   = parser.run(file)

      data.each do |attributes|
        imported_object = Importer::ImportedObject.new(:import => import)

        if object = find_on_import(attributes)
          imported_object.state = "existing_object"
        else
          object                = new
          imported_object.state = "new_object"
        end

        imported_object.data   = attributes
        object.attributes      = attributes

        unless object.save
          imported_object.state             = "invalid_object"
          imported_object.validation_errors = object.errors.full_messages
        end

        imported_object.object = object
        imported_object.save
      end

      import
    end

    def find_on_import(attributes)
      find_by_id(attributes["id"])
    end
  end
end
