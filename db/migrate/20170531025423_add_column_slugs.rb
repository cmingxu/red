class AddColumnSlugs < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :slug, :string
    add_column :apps, :slug, :string
    add_column :service_templates, :slug, :string
    add_column :groups, :slug, :string
  end
end
