class V1::CartedBooksController < ApplicationController

  def index
    carted_books = CartedBook.where(user_id: current_user.id, status: "carted")
    render json: carted_books.as_json
  end

  def create
    carted_book = CartedBook.new(
      user_id: current_user.id,
      book_id: params[:book_id],
      quantity: params[:quantity],
      status: "carted",
    )
    if carted_book.save
      render json: carted_book.as_json, status: :create
    else
      render json: {errors: carted_book.errors.full_messages}, status: :bad_request
    end
  end

  def update
    carted_book = CartedBook.find_by(user_id: current_user.id, id: params[:id])
    if carted_book.status == "carted"
      carted_book.update(status: "removed")
      render json: carted_book.as_json
    elsif carted_book.status == "purchased"
      render json: "You have already purchased this item"
    elsif carted_book.status == "removed"
      render json: "You have already removed this item from your cart"
    else
      render json: {errors: carted_book.errors.full_messages}, status: :bad_request
    end
  end

end
