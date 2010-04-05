module Importer
  # Summary of import.
  # Contains detailed information about import process, all imported objects,
  # no matter if they were imported successfully or not.
  #
  # The importer builds it's Import instance by adding imported objects via
  # +add_object+.
  class Import
    attr_reader :imported_objects

    def initialize
      @imported_objects = []
    end

    def add_object(imported_object)
      imported_objects << imported_object
    end

    def build_imported_object
      ImportedObject.new
    end

    def new_imported_objects
      imported_objects.select { |object| object.state == 'new_object' }
    end

    def existing_imported_objects
      imported_objects.select { |object| object.state == 'existing_object' }
    end

    def invalid_imported_objects
      imported_objects.select { |object| object.state == 'invalid_object' }
    end
  end
end