class CreateNamespaces < ActiveRecord::Migration[5.0]
  def change
    create_table :namespaces do |t|
      t.string :name
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
