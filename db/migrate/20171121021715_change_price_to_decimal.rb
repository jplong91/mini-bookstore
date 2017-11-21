class ChangePriceToDecimal < ActiveRecord::Migration[5.1]
  def change
    change_column :books, :price, "numeric USING CAST(price AS numeric)"
    change_column :books, :price, :decimal, precision: 9, scale: 2
  end
end
