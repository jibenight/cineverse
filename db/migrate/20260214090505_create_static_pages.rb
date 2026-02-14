class CreateStaticPages < ActiveRecord::Migration[7.2]
  def change
    create_table :static_pages do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.text :body_html

      t.timestamps
    end

    add_index :static_pages, :slug, unique: true
  end
end
