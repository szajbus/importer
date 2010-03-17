class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.integer :new_objects_count,      :null => false, :default => 0
      t.integer :existing_objects_count, :null => false, :default => 0
      t.integer :invalid_objects_count,  :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :imports
  end
end
