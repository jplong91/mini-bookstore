Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  namespace :v1 do
    post "/carted_books" => "carted_books#create"
    get "/carted_books" => "carted_books#index"
    patch "/carted_books/:id" => "carted_books#update"

    post "/orders" => "orders#create"
    get "/orders" => "orders#index"

    get "/publishers" => "publishers#index"
    get "/publishers/:id" => "publishers#show"
    post "/publishers" => "publishers#create"
    patch "/publishers/:id" => "publishers#update"
    delete "/publishers/:id" => "publishers#destroy"

    get "/books" => "books#index"
    get "/books/:id" => "books#show"
    post "/books" => "books#create"
    patch "/books/:id" => "books#update"
    delete "/books/:id" => "books#destroy"

    get "/images" => "images#index"
    get "/images/:id" => "images#show"
    post "/images" => "images#create"
    patch "/images/:id" => "images#update"
    delete "/images/:id" => "images#destroy"

    post "/users" => "users#create"
    delete "/users/:id" => "users#destroy"
    get "/current_user" => "users#admin"
  end
end
