class CreateUserDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :user_discounts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :discount_type
      t.string :label
      t.text :description
      t.boolean :shareable, default: false

      t.timestamps
    end
  end
end
