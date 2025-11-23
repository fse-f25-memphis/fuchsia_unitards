class CreateTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :trades do |t|
      t.references :proposer, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.string :status, default: "pending" # pending / accepted / rejected

      t.timestamps
    end
  end
end