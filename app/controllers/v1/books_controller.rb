class V1::BooksController < ApplicationController
  def index
    books = Book.all
    render json: books
  end

  def show
    book_id = params["id"]
    book = Book.find_by(id: book_id)
    render json: book
  end

  def create
    book = Book.create(
      title: params[:title],
      author: params[:author],
      price: params[:price],
      pages: params[:pages],
      image: params[:image]
    )
    render json: book
  end

  def update
    book_id = params["id"]
    book = Book.find_by(id: book_id)
    book.title = params[:title] || book.title
    book.author = params[:author] || book.author
    book.price = params[:price] || book.price
    book.pages = params[:pages] || book.pages
    book.image = params[:image] || book.image
    book.save
    render json: book.as_json
  end

  def destroy
    book_id = params["id"]
    book = Book.find_by(id: book_id)
    book.destroy
    render json: "Book successfully deleted"
  end
end
