module Importer
  module Import
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
    end
  end
end
