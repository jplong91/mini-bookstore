class Book < ApplicationRecord
  def is_discounted
    if price.to_i < 2
      true
    else
      false
    end
  end

  def tax
    price.to_i * (0.09)
  end

  def total
    tax + price.to_i
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
      image: self.image,
      price: self.price,
      price_with_tax: self.total,
      updated_at: self.friendly_updated_at
    }
  end
end
