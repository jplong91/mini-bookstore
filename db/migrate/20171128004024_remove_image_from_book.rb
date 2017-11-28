class RemoveImageFromBook < ActiveRecord::Migration[5.1]
  def change
    remove_column :books, :image, :string
  end
end
