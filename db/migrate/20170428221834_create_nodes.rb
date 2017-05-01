class CreateNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :nodes do |t|
      t.string :hostname
      t.string :state

      t.timestamps
    end
  end
end
