class RenameProductIdinOrder < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :product_id, :book_id
  end
end
