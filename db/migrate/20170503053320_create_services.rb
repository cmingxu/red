class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name
      t.string :desc
      t.boolean :favorite
      t.integer :group_id
      t.integer :user_id

      t.timestamps
    end
  end
end
