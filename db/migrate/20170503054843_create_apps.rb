class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :backend
      t.decimal :cpu, precision: 10, scale: 2
      t.integer :mem
      t.integer :disk
      t.string :cmd
      t.string :args
      t.integer :priority
      t.string :runas
      t.string :constraints
      t.string :image
      t.string :network
      t.text :portmappings
      t.boolean :force_image
      t.boolean :privileged
      t.text :env
      t.text :volumes
      t.text :uris
      t.text :gateway
      t.text :health_check
      t.integer :instances
      t.integer :service_id
      t.integer :current_version_id
      t.text :raw_config

      t.timestamps
    end
  end
end
