module Rails
  module Generator
    class ImporterGenerator < NamedBase
      def banner
        "Usage: #{$0} importer import"
      end

      def manifest
        record do |m|
          time = Time.now
          m.template "imports_migration.rb", "db/migrate/#{time.strftime('%Y%m%d%H%M%S')}_create_imports.rb"
          time += 1
          m.template "imported_objects_migration.rb", "db/migrate/#{time.strftime('%Y%m%d%H%M%S')}_create_imported_objects.rb"
        end
      end
    end
  end
end
