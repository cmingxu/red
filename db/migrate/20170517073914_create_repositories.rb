class CreateRepositories < ActiveRecord::Migration[5.0]
  def change
    create_table :repositories do |t|
      t.string :name
      t.integer :namespace_id
      t.string :latest_tag_name

      t.timestamps
    end
  end
end
