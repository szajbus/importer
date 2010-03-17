require 'crack/xml'

module Importer
  class Parser

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
      @data = []

      file = File.new(@file)
      data = Crack::XML.parse(file)

      root = data.shift[1]

      if root
        objects = root.shift[1]
        @data = objects.is_a?(Hash) ? [objects] : objects
      end
    end
  end
end