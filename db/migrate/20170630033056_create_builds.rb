class CreateBuilds < ActiveRecord::Migration[5.0]
  def change
    create_table :builds do |t|
      t.integer :project_id
      t.integer :serial_num
      t.string :version_name
      t.string :build_status

      t.timestamps
    end
  end
end
