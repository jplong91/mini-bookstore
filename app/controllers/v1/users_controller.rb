class V1::UsersController < ApplicationController

  def create
    user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    if user.save
      render json: {status: "User successfully created"}, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    user_id = params["id"]
    user = User.find_by(id: user_id)
    user.destroy
    render json: "User deleted"
  end

  def admin
    user_id = current_user.id
    user = User.find_by(id: user_id)
    render json: user.as_json
  end

end
