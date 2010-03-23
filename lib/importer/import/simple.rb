module Importer
  module Import
    # Simple import summary. It's not stored in database (as with +ActiveRecord+ import).
    #
    # Attributes:
    # * +new_objects_count+ - number of new objects created during the import
    # * +existing_objects_count+ - number of objects modified during the import
    # * +invalid_objects_count+ - number of objects that couldn't have been imported
    # * +workflow_state+ - import may be in one of three states: ready, started or
    #   finished. The state changes during the import process.
    class Simple
      attr_reader :state, :new_objects_count, :existing_objects_count, :invalid_objects_count, :imported_objects

      class << self
        def create
          import = new
          import.save
          import
        end
      end

      def initialize
        @state                  = "ready"
        @new_objects_count      = 0
        @existing_objects_count = 0
        @invalid_objects_count  = 0
        @imported_objects       = []
      end

      def start!
        @state = "started"
      end

      def finish!
        @state = "finished"
      end

      def add_object(imported_object)
        case imported_object.state
        when "new_object"
          @new_objects_count += 1
        when "existing_object"
          @existing_objects_count += 1
        when "invalid_object"
          @invalid_objects_count += 1
        end
        @imported_objects << imported_object
      end

      def save
        true
      end

      alias_method :save!, :save

      def build_imported_object
        Importer::ImportedObject::Simple.new(:import => self)
      end
    end
  end
end
