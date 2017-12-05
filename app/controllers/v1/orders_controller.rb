class V1::OrdersController < ApplicationController

  def create
    carted_books = CartedBook.where(user_id: current_user.id, status: "carted")

    subtotal = 0

    carted_books.each do |indiv|
      book = Book.find_by(id: indiv[:book_id])
      subtotal += book[:price] * indiv[:quantity]
    end

    tax = subtotal * 0.09

    order = Order.new(
      user_id: current_user.id,
      subtotal: subtotal,
      tax: tax,
      total: subtotal + tax
    )
    if order.save
      carted_books.update_all(status: "purchased", order_id: order[:id])
      render json: order.as_json, status: :created
    else
      render json: {errors: order.errors.full_messages}, status: :bad_request
    end
  end

  def index
    orders = Order.where(user_id: current_user.id)
    render json: orders.as_json
  end

end
