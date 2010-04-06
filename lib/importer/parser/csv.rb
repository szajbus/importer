require 'fastercsv'

module Importer
  module Parser
    # CSV parser
    # Uses fastercsv lib to parse the CSV files.
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