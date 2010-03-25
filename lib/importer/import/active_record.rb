require 'active_record'
require 'workflow'

module Importer
  module Import
    # ActiveRecord model that stores import summaries in imports database table.
    # has_many :+imported_objects+
    #
    # Attributes:
    # * +new_objects_count+ - number of new objects created during the import
    # * +existing_objects_count+ - number of objects modified during the import
    # * +invalid_objects_count+ - number of objects that couldn't have been imported
    # * +workflow_state+ - import may be in one of three states: ready, started or
    #   finished. The state changes during the import process.
    class ActiveRecord < ::ActiveRecord::Base
      set_table_name "imports"

      include Workflow

      workflow do
        state :ready do
          event :start,   :transitions_to => :started
        end
        state :started do
          event :finish,  :transitions_to => :finished
        end
        state :finished
      end

      named_scope :ready,    :conditions => { :workflow_state => "ready" }
      named_scope :started,  :conditions => { :workflow_state => "started" }
      named_scope :finished, :conditions => { :workflow_state => "finished" }

      has_many :imported_objects, :class_name => "Importer::ImportedObject::ActiveRecord", :foreign_key => "import_id"

      def build_imported_object
        imported_objects.build(:import => self)
      end
    end
  end
end
