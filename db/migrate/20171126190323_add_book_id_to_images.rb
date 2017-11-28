class AddBookIdToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :book_id, :integer
  end
end
