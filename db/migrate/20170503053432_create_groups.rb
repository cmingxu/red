class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id
      t.text :desc
      t.string :icon

      t.timestamps
    end

    add_index :groups, :owner_id
  end

end
