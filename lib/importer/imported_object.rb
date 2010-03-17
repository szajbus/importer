module Importer
  class ImportedObject < ::ActiveRecord::Base
    named_scope :new_objects,       :conditions => { :state => "new_object" }
    named_scope :existing_objects,  :conditions => { :state => "existing_object" }
    named_scope :invalid_objects,   :conditions => { :state => "invalid_object" }

    belongs_to  :import, :class_name => "Importer::Import"
    belongs_to  :object, :polymorphic => true

    after_save    :increment_counter
    after_destroy :decrement_counter

    serialize :data

    protected

    def increment_counter
      import.increment!("#{state}s_count") if import
    end

    def decrement_counter
      import.decrement!("#{state}s_count") if import
    end
  end
end