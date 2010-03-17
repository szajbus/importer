class CreateImportedObjects < ActiveRecord::Migration
  def self.up
    create_table :imported_objects do |t|
      t.integer :import_id,         :null => false
      t.string  :object_type
      t.integer :object_id
      t.string  :data
      t.string  :validation_errors
      t.string  :state,             :null => false, :limit => 20
      t.timestamps
    end
    add_index :imported_objects, :import_id
  end

  def self.down
    remove_index :imported_objects, :import_id
    drop_table :imported_objects
  end
end
