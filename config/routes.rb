Rails.application.routes.draw do
  get "/the_way_of_kings" => "books#kings"
  get "/the_eye_of_the_world" => "books#eye"
  get "/the_name_of_the_wind" => "books#wind"
end
