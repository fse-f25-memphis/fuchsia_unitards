class CreateTradeItems < ActiveRecord::Migration[7.1]
  def change
    create_table :trade_items do |t|
      t.references :trade, null: false, foreign_key: true
      t.references :unitard, null: false, foreign_key: true
      t.string :side, null: false # "proposer" or "recipient"

      t.timestamps
    end
  end
end
