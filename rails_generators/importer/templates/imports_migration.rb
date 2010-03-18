class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.integer :new_objects_count,      :null => false, :default => 0
      t.integer :existing_objects_count, :null => false, :default => 0
      t.integer :invalid_objects_count,  :null => false, :default => 0
      t.string  :workflow_state,         :null => false, :default => "ready", :limit => 10
      t.timestamps
    end
    add_index :imports, :workflow_state
  end

  def self.down
    remove_index :imports, :workflow_state
    drop_table :imports
  end
end
