class BooksController < ApplicationController
  def kings
    book = Book.first
    render json: book
  end

  def eye
    book = Book.second
    render json: book
  end

  def wind
    book = Book.third
    render json: book
  end
end
