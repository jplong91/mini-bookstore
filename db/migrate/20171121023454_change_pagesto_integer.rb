class ChangePagestoInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :books, :pages, "numeric USING CAST(price AS numeric)"
    change_column :books, :pages, :integer
  end
end
