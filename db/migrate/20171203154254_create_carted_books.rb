class CreateCartedBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :carted_books do |t|
      t.integer :user_id
      t.integer :book_id
      t.integer :quantity
      t.string :status
      t.integer :order_id

      t.timestamps
    end
  end
end
