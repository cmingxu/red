class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :salt
      t.string :encrypted_password
      t.text :icon
      t.text :bio
      t.string :role

      t.timestamps
    end
  end
end
