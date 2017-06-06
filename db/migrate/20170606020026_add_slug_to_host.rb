class AddSlugToHost < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :slug, :string
  end
end
