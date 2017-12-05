class V1::BooksController < ApplicationController
  # before_action :authenticate_user
  before_action :authenticate_admin, except: [:index, :show]

  def index
    books = Book.all.order(:id => :asc)
    if params[:search]
      books = books.where("title ILIKE ?", "%#{params[:search]}%")
    end
    if params[:category_id]
      books = Category.find_by(id: params[:category_id]).books
    end
    if params[:sort_by_price]
      books = Book.order(:price => :asc)
    end
    render json: books.as_json
  end

  def show
    if current_user
      book_id = params["id"]
      book = Book.find_by(id: book_id)
      render json: book.as_json
    else
      render json: "Please login to view your books", status: :bad_request
    end
  end

  def create
    book = Book.new(
      title: params[:title],
      author: params[:author],
      price: params[:price],
      pages: params[:pages],
      publisher_id: params[:publisher_id]
    )
    if book.save
      render json: book.as_json
    else
      render json: {errors: book.errors.full_messages}, status: :bad_request
    end
  end

  def update
    book_id = params["id"]
    book = Book.find_by(id: book_id)
    book.title = params[:title] || book.title
    book.author = params[:author] || book.author
    book.price = params[:price] || book.price
    book.pages = params[:pages] || book.pages
    book.in_stock = params[:in_stock] || book.in_stock
    if book.save
      render json: book.as_json
    else
      render json: {errors: book.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    book_id = params["id"]
    book = Book.find_by(id: book_id)
    book.destroy
    render json: "Book successfully deleted"
  end
  
end
