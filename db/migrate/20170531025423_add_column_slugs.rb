class AddColumnSlugs < ActiveRecord::Migration[5.0]
  def change
    %w{services apps service_templates groups namespaces}.each do |table|
      add_column table, :slug, :string
      add_index table, :slug
    end
  end
end
