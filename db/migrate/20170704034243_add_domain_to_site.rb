class AddDomainToSite < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :domain, :string
  end
end
