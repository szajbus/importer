require 'importer/parser'

module Importer

  class << self
    def included(base)
      base.send(:extend,  Importer::ClassMethods)
    end
  end

  module ClassMethods
    def import(file)
      data = Importer::Parser.run(file)

      data.each do |attributes|
        object = find_on_import(attributes) || new

        object.attributes = attributes
        object.save
      end
    end

    def find_on_import(attributes)
      find_by_id(attributes["id"])
    end
  end
end