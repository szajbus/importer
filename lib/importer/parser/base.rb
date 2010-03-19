module Importer
  module Parser
    class Base

      class << self
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

      def run
        raise Exception.new("This method must be implemented in subclasses.")
      end
    end
  end
end