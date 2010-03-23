require 'active_support'

require 'importer/import'
require 'importer/imported_object'
require 'importer/import/active_record'
require 'importer/import/simple'
require 'importer/imported_object/active_record'
require 'importer/imported_object/simple'
require 'importer/parser'
require 'importer/parser/base'
require 'importer/parser/csv'
require 'importer/parser/xml'

# Importer is a tool to help you with importing objects to your database from various sources.
#
# Usage:
#
#   class Product < ActiveRecord::Base
#     include Importer
#   end
#
#   Product.import(path_to_xml_or_csv_file)
#
# Check README.rdoc file for more useful information
#
# Author:: Michal Szajbe
# Copyright:: Copyright (c) 2010 Michal Szajbe
# License:: check the LICENCE file
module Importer

  class << self
    def included(base)
      base.send(:include, Importer::InstanceMethods)
      base.send(:extend,  Importer::ClassMethods)
    end
  end

  module ClassMethods
    # The import process is wrapped in a transaction, so if anything goes wrong there is no
    # harm done.
    # * +file+ - path to an XML or CVS file, you can also import from other data formats,
    #   but you also need to provide a custom parser to read it
    # Possible options:
    # * +parser+ - by default the parser is determined from file extension, but you can force
    #   the imported to use another one by passing it's class here
    # * +import+ - by default importer tries to store import summary in database, so it uses
    #   ActiveRecord import, to use other import type pass it's instance here
    def import(file, options = {})
      import = options[:import] || Importer::Import::ActiveRecord.create
      parser = options[:parser] || Importer::Parser.get_klass(file)
      data   = parser.run(file)

      transaction do
        import.start!

        data.each do |attributes|
          imported_object = import.build_imported_object

          if object = find_on_import(import, attributes)
            imported_object.state = "existing_object"
          else
            object                = new
            imported_object.state = "new_object"
          end

          imported_object.data = attributes
          object.merge_attributes_on_import(import, attributes)

          unless object.save
            imported_object.state             = "invalid_object"
            imported_object.validation_errors = object.errors.full_messages
          end

          imported_object.object = object
          imported_object.save
        end

        import.finish!
      end

      import
    end

    # Overload +find_on_import+ method to find existing objects while importing an object.
    # This is used to determine wheter an imported should add a new object or just modify
    # an existing one. By default it searches records by id.
    def find_on_import(import, attributes)
      find_by_id(attributes["id"])
    end
  end

  module InstanceMethods
    # Overload +merge_attributes_on_import+ method if you need the detected attributes
    # merged to an object in some specific way. By default detected attributes are literally
    # assigned to an object.
    def merge_attributes_on_import(import, attributes)
      self.attributes = attributes
    end
  end
end
