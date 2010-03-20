module Importer
  module ImportedObject
    def self.get_klass(import)
      import.class.to_s.sub("Importer::Import", "Importer::ImportedObject").constantize
    end
  end
end