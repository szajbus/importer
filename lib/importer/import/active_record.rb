require 'active_record'
require 'workflow'

module Importer
  module Import
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

      has_many :imported_objects, :class_name => "Importer::ImportedObject::ActiveRecord"
    end
  end
end
