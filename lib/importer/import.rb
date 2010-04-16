module Importer
  # Summary of import.
  # Contains detailed information about import process, all imported objects,
  # no matter if they were imported successfully or not.
  #
  # The importer builds it's Import instance by adding imported objects via
  # +add_object+.
  #
  # If you want to have your own implementation of Import summary
  # (f.e. activerecord-based), you can force the importer to use it with:
  #
  #    Product.import(path_to_xml_or_csv_file, :import => CustomImportClass)
  #
  # Just be sure to implement +add_object+ and +build_imported_object+
  # methods in your custom class.
  class Import
    attr_reader :options, :imported_objects

    def initialize(options = nil)
      @imported_objects = []
      @options          = options
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
