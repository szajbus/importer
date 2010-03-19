module Importer
  class ParserNotFoundError < ::Exception; end

  module Parser
    def self.get_klass(file)
      extension = File.extname(file)[1..-1]

      if extension
        klass = extension.camelize

        if Importer::Parser.const_defined?(klass.to_sym)
          klass = "Importer::Parser::#{klass}".constantize
          return klass
        end
      end

      raise Importer::ParserNotFoundError.new("Can't find #{klass} parser.")
    end
  end
end
