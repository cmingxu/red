class CreateAudits < ActiveRecord::Migration[5.0]
  def change
    create_table :audits do |t|
      t.string :owner_type
      t.integer :owner_id
      t.datetime :when
      t.string :entity_type
      t.integer :entity_id
      t.string :enetity_desc
      t.text :change

      t.timestamps
    end
  end
end
