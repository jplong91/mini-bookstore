class RemoveBookIdFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :book_id, :integer
    remove_column :orders, :quantity, :integer
  end
end
