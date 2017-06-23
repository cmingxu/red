class AddOutputServiceToAppLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :app_links, :output_service, :string
  end
end
