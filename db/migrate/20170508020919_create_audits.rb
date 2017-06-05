class CreateAudits < ActiveRecord::Migration[5.0]
  def change
    create_table :audits do |t|
      t.integer :user_id
      t.datetime :when
      t.string :entity_type
      t.string :enetity_desc
      t.string :action
      t.text :change
      t.integer :entity_id

      t.timestamps
    end

    add_index :audits, :entity_id
    add_index :audits, :user_id
    add_index :audits, [:entity_type, :entity_id]
  end
end
