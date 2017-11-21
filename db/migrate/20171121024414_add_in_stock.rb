class AddInStock < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :in_stock, :boolean, default: true
  end
end
