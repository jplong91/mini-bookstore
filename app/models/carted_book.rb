class CartedBook < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :order, optional: true
  validates :quantity, numericality: { greater_than: 0 }

  def as_json
    {
      id: self.id,
      user_id: self.user_id,
      book_id: self.book_id,
      quantity: self.quantity,
      status: self.status,
      order_id: self.order_id
    }
  end

end
