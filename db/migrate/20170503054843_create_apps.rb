class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :backend
      t.integer :instances
      t.integer :service_id
      t.integer :current_version_id
      t.text :raw_config

      t.timestamps
    end
  end
end
