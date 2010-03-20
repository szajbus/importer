require 'active_record'

module Importer
  module ImportedObject
    # ActiveRecord model that stores detailed information of imported objects in
    # imported_objects database table.
    #
    # belongs_to :import - reference to import instance
    # belongs_to :object - reference to imported object
    #
    # Attributes:
    # * +data+ - object's detected attributes hash
    # * +validation_errors+ - object's validation errors hash.
    class ActiveRecord < ::ActiveRecord::Base
      set_table_name "imported_objects"

      named_scope :new_objects,       :conditions => { :state => "new_object" }
      named_scope :existing_objects,  :conditions => { :state => "existing_object" }
      named_scope :invalid_objects,   :conditions => { :state => "invalid_object" }

      belongs_to  :import, :class_name => "Importer::Import::ActiveRecord"
      belongs_to  :object, :polymorphic => true

      after_save    :increment_counter
      after_destroy :decrement_counter

      serialize :data
      serialize :validation_errors

      protected

      def increment_counter
        import.increment!("#{state}s_count") if import
      end

      def decrement_counter
        import.decrement!("#{state}s_count") if import
      end
    end
  end
end