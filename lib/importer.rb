require 'importer/adapters/active_record_adapter'
require 'importer/adapters/data_mapper_adapter'
require 'importer/adapters/mongo_mapper_adapter'
require 'importer/import'
require 'importer/imported_object'
require 'importer/parser'
require 'importer/parser/base'
require 'importer/parser/csv'
require 'importer/parser/xml'

# Importer module provides your models with flexible API that makes it easier
# to import data from external sources.
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
  class AdapterError < ::Exception; end

  class << self
    def included(base)
      if base.respond_to?(:descends_from_active_record?) && base.descends_from_active_record?
        base.send(:include, Importer::Adapters::ActiveRecordAdapter)
      elsif defined?(MongoMapper) && (base.ancestors.include?(MongoMapper::Document) || base.ancestors.include?(MongoMapper::EmbeddedDocument))
        base.send(:include, Importer::Adapters::MongoMapperAdapter)
      elsif defined?(DataMapper) && (base.ancestors.include?(DataMapper::Resource))
        base.send(:include, Importer::Adapters::DataMapperAdapter)
      else
        raise AdapterError.new("Can't determine adapter for #{base.class} class.")
      end
    end
  end

end
