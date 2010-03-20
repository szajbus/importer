module Importer
  module Parser
    # Extend this class if you want to provide a custom parser.
    # You only need to implement +run+ instance method in subclasses.
    class Base

      class << self
        # Creates parser instance and processes the +file+
        def run(file)
          parser = new(file)
          parser.run
          parser.data
        end
      end

      attr_reader :data

      def initialize(file)
        @file = file
        @data = []
      end

      # This method must be implemented in subclasses.
      # It is meant to process input @file, and store the results in @data instance
      # variable.
      def run
        raise Exception.new("This method must be implemented in subclasses.")
      end
    end
  end
end