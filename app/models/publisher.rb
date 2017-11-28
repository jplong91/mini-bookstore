class Publisher < ApplicationRecord

  has_many :books
  # def books
  #   Book.where(publisher_id: self.id)
  # end

  def as_json
    {
      id: self.id,
      name: self.name,
      email: self.email,
      phone_number: self.phone_number
    }
  end
end
