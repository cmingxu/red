class CreateRepoTags < ActiveRecord::Migration[5.0]
  def change
    create_table :repo_tags do |t|
      t.string :name
      t.integer :repository_id
      t.integer :namespace_id
      t.integer :blob_size
      t.string :owner_name
      t.string :digest
      t.string :url
      t.string :source
      t.integer :user_id

      t.timestamps
    end
  end
end
