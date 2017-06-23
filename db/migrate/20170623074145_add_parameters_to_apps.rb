class AddParametersToApps < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :parameters, :text
    add_column :apps, :labels, :text
  end
end
