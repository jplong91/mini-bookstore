require "unirest"
require "tty-prompt"
prompt = TTY::Prompt.new

while true
  mm_options = {
    "View Individual Book" => 1, 
    "View All Books" => 2, 
    "Exit" => 3, 
  }
  input_main_option = prompt.select("\nMain Menu Options", mm_options)
  if input_main_option == 3
    "\nGoobye"
    break
  elsif input_main_option == 1
    book_menu_options = {
    "The Way of Kings" => 1, 
    "The Eye of the World" => 2, 
    "The Name of the Wind" => 3, 
    }
    input_book_option = prompt.select("\nSelect a Book", book_menu_options)
    if input_book_option == 1
      response = Unirest.get("http://localhost:3000/the_way_of_kings")
      book = response.body
      puts
      puts book["title"]
      puts book["author"]
      puts "Number of pages: #{book["pages"]}"
      # puts book["image"]
    elsif input_book_option == 2
      response = Unirest.get("http://localhost:3000/the_eye_of_the_world")
      book = response.body
      puts
      puts book["title"]
      puts book["author"]
      puts "Number of pages: #{book["pages"]}"
    elsif input_book_option == 3
      response = Unirest.get("http://localhost:3000/the_name_of_the_wind")
      book = response.body
      puts
      puts book["title"]
      puts book["author"]
      puts "Number of pages: #{book["pages"]}"
    end
  elsif input_main_option == 2
    response = Unirest.get("http://localhost:3000/all_books")
    books = response.body
    books.each do |indiv|
      puts
      puts indiv["title"]
      puts indiv["author"]
      puts "Number of pages: #{indiv["pages"]}"
    end
  end
end