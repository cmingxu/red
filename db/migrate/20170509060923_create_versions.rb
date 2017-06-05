class CreateVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :versions do |t|
      t.string :name
      t.text :raw_config
      t.integer :app_id

      t.timestamps
    end

    add_index :versions, :app_id
  end
end
