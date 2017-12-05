class Order < ApplicationRecord
  belongs_to :user
  has_many :carted_products

  # def subtotal_a
  #   self.subtotal * quantity
  # end

  # def tax_a
  #   self.tax * quantity
  # end

  # def total_a
  #   self.total * quantity
  # end

  def as_json
    {
      id: self.id,
      subtotal: self.subtotal,
      tax: self.tax,
      total: self.total
    }
  end

end
