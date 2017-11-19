Rails.application.routes.draw do
  namespace :v1 do
    get "/books" => "books#index"
    get "/books/:id" => "books#show"
    post "/books" => "books#create"
    patch "/books/:id" => "books#update"
    delete "/books/:id" => "books#destroy"
  end
end
