class CreateBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :badges do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.text :description
      t.string :icon
      t.integer :category
      t.string :condition_type
      t.integer :condition_value

      t.timestamps
    end

    add_index :badges, :slug, unique: true
  end
end
