class AddColumnToNode < ActiveRecord::Migration[5.0]
  def change
    add_column :nodes, :cpu, :integer
    add_column :nodes, :mem, :integer
    add_column :nodes, :docker_version, :string
    add_column :nodes, :pubkey, :string
  end
end
