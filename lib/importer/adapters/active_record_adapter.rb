module Importer
  module Adapters
    # Adapter for ActiveRecord models
    #
    # Usage:
    #
    #   class Product < ActiveRecord::Base
    #     include Importer
    #   end
    #
    #   Product.import(path_to_xml_or_csv_file)
    #
    # It sends the given file to a parser and then imports detected objects.
    # Instead of simply inserting all detected objects to database, the importer
    # tries to determine wheter a detected object already exists. If so, the object
    # is only updated, otherwise a new object is created.
    #
    # To change the way how importer checks for existing objects (or to turn off this
    # behavior completely) override +find_on_import+ method. The default behavior now
    # is to try to find existing object by detected object's id.
    #
    # By default the detected object's attributes hash is literally assigned to a
    # soon-to-be-saved object. If there is a need for more sophisticated behavior,
    # simply override +merge_attributes_on_import+ method.
    module ActiveRecordAdapter

      class << self
        def included(base)
          base.send(:include, InstanceMethods)
          base.send(:extend,  ClassMethods)
        end
      end

      module ClassMethods
        # The import process is wrapped in a transaction, so if anything goes wrong there is no
        # harm done.
        # * +file+ - path to an XML or CVS file, you can also import from other data formats,
        #   but you also need to provide a custom parser to read it
        # Possible options:
        # * +parser+ - by default the parser is determined from file extension, but you can force
        #   the imported to use another one by passing it's class here
        # * +import+ - by default importer returns instance of +Import+ class that contains
        #   detailed report of import process, you can implement your own Import class and force
        #   the importer to use it by passing it's class here
        # * +import_options+ - options passed to Import instance on it's initialization
        def import(file, options = {})
          import = (options[:import] || Importer::Import).new(options[:import_options])
          parser =  options[:parser] || Importer::Parser.get_klass(file)
          data   = parser.run(file)

          transaction do
            data.each do |attributes|
              imported_object = import.build_imported_object

              if object = find_on_import(import, attributes)
                imported_object.state = "existing_object"
              else
                object                = new
                imported_object.state = "new_object"
              end

              imported_object.data = attributes
              object.merge_attributes_on_import(import, attributes)

              unless object.save
                imported_object.state             = "invalid_object"
                imported_object.validation_errors = object.errors.full_messages
              end

              imported_object.object = object

              import.add_object(imported_object)
            end
          end

          import
        end

        # Determines whether a detected object already exists in database.
        # By default it tries to find an existing objects by id of the detected one.
        # Returns the object or nil if it's not found.
        # Override this method in your model to change that default behavior.
        # * +import+ - current import
        # * +attributes+ - detected object's attributes hash
        def find_on_import(import, attributes)
          find_by_id(attributes["id"])
        end
      end

      module InstanceMethods
        # Merges attributes of a detected object with current object's ones.
        # By default it simply assigns detected attributes to the object.
        # Override this method in your model to provide some more sophisticated
        # behavior.
        # * +import+ - current import
        # * +attributes+ - detected object's attributes hash
        def merge_attributes_on_import(import, attributes)
          self.attributes = attributes
        end
      end
    end
  end
end