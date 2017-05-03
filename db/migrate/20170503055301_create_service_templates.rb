class CreateServiceTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :service_templates do |t|
      t.string :name
      t.string :icon
      t.integer :group_id
      t.integer :user_id
      t.text :raw_config
      t.string :desc
      t.text :readme

      t.timestamps
    end
  end
end
