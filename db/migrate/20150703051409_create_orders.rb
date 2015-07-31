class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :client
      t.integer :status
      t.string :order_message
      t.integer :payment
      t.integer :num_comment
      t.integer :num_view
      t.integer :num_pop
      t.datetime :order_date
      t.datetime :close_date
      t.string :list_image_name

      t.timestamps
    end
  end
end
