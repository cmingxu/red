class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :tagable_type
      t.integer :tagable_id
      t.string :name

      t.timestamps
    end
  end
end
