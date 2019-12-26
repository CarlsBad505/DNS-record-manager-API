class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.integer :zone_id, null: false
      t.string :name, null: false
      t.string :type, null: false
      t.string :data, null: false
      t.integer :ttl, default: 3600
      t.boolean :soa, default: false
      t.integer :revised_at
      t.integer :refresh_time
      t.integer :retry_time
      t.integer :expires_at

      t.timestamps
    end
    add_index :records, :zone_id
  end
end
