class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name
      t.integer :group_id
      t.integer :user_id

      t.timestamps
    end
  end
end
