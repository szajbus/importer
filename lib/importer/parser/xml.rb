require 'crack/xml'

module Importer
  module Parser
    class Xml < Base
      def run
        @data = []

        file = File.new(@file)
        data = Crack::XML.parse(file)

        root = data.shift[1]

        if root
          objects = root.shift[1]
          @data = objects.is_a?(Hash) ? [objects] : objects
        end

        @data
      end
    end
  end
end