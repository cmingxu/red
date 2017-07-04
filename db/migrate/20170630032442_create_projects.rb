class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :namespace_id
      t.text :dockerfile
      t.integer :user_id
      t.integer :group_id
      t.string :version_format
      t.string :slug
      t.string :token

      t.timestamps
    end
  end
end
