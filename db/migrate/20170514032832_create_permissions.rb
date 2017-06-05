class CreatePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions do |t|
      t.string :resource_type
      t.integer :resource_id
      t.integer :access
      t.string :accessor_type
      t.integer :accessor_id

      t.timestamps
    end

    add_index :permissions, [:resource_type, :resource_id]
    add_index :permissions, [:accessor_type, :accessor_id]
  end
end
