class AddRegistryDomainToConfig < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :registry_domain, :string
  end
end
