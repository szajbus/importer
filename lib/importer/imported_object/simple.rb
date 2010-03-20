module Importer
  module ImportedObject
    # Simple imported object details. It's not stored in database (as with
    # +ActiveRecord+ imported object).
    #
    # Attributes:
    # * +data+ - object's detected attributes hash
    # * +validation_errors+ - object's validation errors hash
    class Simple
      attr_reader   :import
      attr_accessor :state, :object, :data, :validation_errors

      def initialize(attributes = {})
        raise ArgumentError.new(":import attribute is required.") unless attributes[:import]
        @import = attributes[:import]
      end

      def save
        import.add_object(self)
      end

      alias_method :save!, :save
    end
  end
end