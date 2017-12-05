class Category < ApplicationRecord
  has_many :category_books

  has_many :books, through: :category_books

  def as_json
    {
      id: self.id,
      name: self.name
    }
  end
end
