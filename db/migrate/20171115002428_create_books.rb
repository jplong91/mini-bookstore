class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :price
      t.string :pages
      t.string :image

      t.timestamps
    end
  end
end
