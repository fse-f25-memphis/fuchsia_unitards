class CreateUnitards < ActiveRecord::Migration[7.1]
  def change
    create_table :unitards do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :cut  # Womens, Mens, Child
      t.string :size # S, M, L, XL, XXL, XXXL
      t.string :sleeves
      t.string :graphic
      t.string :color
      t.text :special_features
      t.integer :stock, default: 0, null: false

      t.references :vendor, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
