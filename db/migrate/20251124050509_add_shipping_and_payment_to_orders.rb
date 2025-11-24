class AddShippingAndPaymentToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :shipping_street, :string
    add_column :orders, :shipping_city, :string
    add_column :orders, :shipping_state, :string
    add_column :orders, :shipping_zip, :string
    add_column :orders, :shipping_country, :string
    add_column :orders, :payment_method, :string
    add_column :orders, :payment_status, :string, default: 'pending'
  end
end