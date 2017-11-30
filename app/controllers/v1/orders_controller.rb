class V1::OrdersController < ApplicationController

  def create
    order = Order.new(
      user_id: current_user.id,
      book_id: params[:book_id],
      quantity: params[:quantity],
      subtotal: params[:price].to_f * params[:quantity].to_f,
      tax: params[:tax].to_f * params[:quantity].to_f,
      total: params[:total].to_f * params[:quantity].to_f
    )
    if order.save
      render json: order.as_json, status: :created
    else
      render json: {errors: order.errors.full_messages}, status: :bad_request
    end
  end

end
