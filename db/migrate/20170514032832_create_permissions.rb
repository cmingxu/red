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
  end
end
