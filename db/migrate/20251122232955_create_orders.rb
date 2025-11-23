class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total
      t.string :status
      t.boolean :gift
      t.string :recipient_name
      t.string :recipient_email
      t.text :gift_message

      t.timestamps
    end
  end
end
