class Order < ApplicationRecord
  belongs_to :user
  belongs_to :book

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
      book_id: self.book_id,
      quantity: self.quantity,
      subtotal: self.subtotal,
      tax: self.tax,
      total: self.total
    }
  end

end
