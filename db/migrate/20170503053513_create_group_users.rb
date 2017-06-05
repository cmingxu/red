class CreateGroupUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :group_users do |t|
      t.integer :group_id
      t.integer :user_id
      t.integer :role

      t.timestamps
    end

    add_index :group_users, :group_id
    add_index :group_users, :user_id
  end
end
