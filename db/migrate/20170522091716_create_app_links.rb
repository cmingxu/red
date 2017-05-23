class CreateAppLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :app_links do |t|
      t.integer :service_id
      t.string :alias
      t.integer :input_app_id
      t.integer :output_app_id

      t.timestamps
    end
  end
end
