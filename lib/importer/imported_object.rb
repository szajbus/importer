module Importer
  # Instances of this class are created during import process and contain
  # detailed information about imported objects.
  #
  # Attributes:
  # * +state+ - an imported object can be in one of three states:
  #   * new_object - new object was detected and successfully imported
  #   * existing_object - already existing object was detected and successfully
  #     imported
  #   * invalid_object - detected object could not have been imported because of
  #     validation errors
  # * +object+ - pointer to actual object created or updated during import
  # * +data+ - detected object's attributes hash
  # * +validation_errors+ - list of validation errors for invalid object
  #
  # Instances of this class are built via Import's +build_imported_object+ method.
  #
  # If you need you can implement your own version of ImportedObject class
  # (f.e. activerecord-based). To use it you must also implement custom version of
  # +Import+ class that builds instances of CustomImportedObject with it's
  # +build_imported_object+ method.
  class ImportedObject
    attr_accessor :state, :object, :data, :validation_errors

    def initialize(attributes = {})
      @state             = attributes[:state]
      @object            = attributes[:object]
      @data              = attributes[:data]
      @validation_errors = attributes[:validation_errors]
    end
  end
end
