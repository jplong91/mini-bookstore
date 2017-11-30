class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :pages, numericality: { only_integer: true }

  belongs_to :publisher
  has_many :orders
  has_many :images

  def is_discounted
    if price < 2
      true
    else
      false
    end
  end

  def tax
    price * (0.09)
  end

  def total
    tax + price
  end

  def friendly_updated_at
    updated_at.strftime("%B %e, %Y")
  end

  def as_json
    {
      id: self.id,
      title: self.title,
      author: self.author,
      pages: self.pages,
      image: self.images.map { |image| image.url },
      in_stock: self.in_stock,
      price: self.price,
      tax: self.tax,
      price_with_tax: self.total,
      updated_at: self.friendly_updated_at,
      publisher: self.publisher.as_json
    }
  end
end
