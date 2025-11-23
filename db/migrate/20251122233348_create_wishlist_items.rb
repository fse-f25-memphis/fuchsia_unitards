class CreateWishlistItems < ActiveRecord::Migration[7.1]
  def change
    create_table :wishlist_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :unitard, null: false, foreign_key: true

      t.timestamps
    end
  end
end
