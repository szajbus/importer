require 'fastercsv'

# CSV parser
# It uses fastercsv lib to parse the files.
module Importer
  module Parser
    class Csv < Base
      def run
        @data = []

        data = FasterCSV.read(@file, :skip_blanks => true)

        unless data.empty?
          attributes = data.shift
          @data = data.map do |values|
            Hash[*attributes.zip(values).flatten]
          end
        end

        @data
      end
    end
  end
end