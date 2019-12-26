class CreateZones < ActiveRecord::Migration[6.0]
  def change
    create_table :zones do |t|
      t.integer :user_id, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :zones, :user_id
  end
end
