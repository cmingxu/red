class AddStateToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :state, :string
  end
end
