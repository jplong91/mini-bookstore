require "unirest"
require "tty-prompt"
require "tty-table"

# class Frontend
#   def initialize
#     @prompt = TTY::Prompt.new
#     @base_url = "jfkdls"
#   end

#   def compile_book_menu
#   end

#   def show_single_book
#   end

#   def run
#   end
# end

# frontend = Frontend.new
# frontend.run


prompt = TTY::Prompt.new
$base_url = "http://localhost:3000/v1/"

def compile_book_menu
  book_menu_options = {}
  response = Unirest.get("#{$base_url}books")
  books = response.body
  books.each do |indiv|
    book_menu_options[indiv["title"]] = indiv["id"]
  end
  return book_menu_options
end

def show_single_book(book)
  puts "\nBook Details"
  puts "*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*"
  puts "Title: #{book["title"]}"
  puts "Author: #{book["author"]}"
  puts "Book Price: #{book["price"]}"
  puts "Number of pages: #{book["pages"]}"
  puts "Book in stock: #{book["in_stock"]}"
  puts "Publisher: #{book["publisher"]["name"]}"
  puts "Cover Image (hold cmd + double click on URL to view in browser): "
  puts "#{book["image"][0]}"
  puts "*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*"
end

# Main Loop
while true
  mm_options = {
    "View a Book" => 1, 
    "View all Books" => 2,
    "Add a Book" =>3,
    "Update a Book" => 4,
    "Remove a Book" => 5,
    "User Menu" => 10,
    "Exit" => 6
  }
  input_main_option = prompt.select("\n@----- MAIN MENU -----@", mm_options)
  
  # Exit
  if input_main_option == 6
    puts "\nGoobye"
    break

  # User Menu
  elsif input_main_option == 10
    usermenu_options = {
      "Create User" => 1,
      "Login" => 2,
      "Logout" => 3,
      "Delete User" => 4,
      "Back to Main Menu" => 5
    }
    usermenu_selection = prompt.select("\nUSER MENU", usermenu_options)

    # Back to MM
    if usermenu_selection == 5

    # Create User
    elsif usermenu_selection == 1
      params = {}
      print "Name: "
      params[:name] = gets.chomp
      print "Email: "
      params[:email] = gets.chomp
      print "Password: "
      params[:password] = gets.chomp
      print "Confirm Password: "
      params[:password_confirmation] = gets.chomp

      response = Unirest.post("#{$base_url}users", parameters: params)
      puts response.body

    # Delete User
    elsif usermenu_selection == 4
      print "Enter the ID of the user you would like to delete: "
      delete_id = gets.chomp
      response = Unirest.delete("#{$base_url}users/#{delete_id}")
      puts
      puts response.body

    # Login
    elsif usermenu_selection == 2
      params = {}
      print "Email: "
      params[:email] = gets.chomp
      print "Password: "
      params[:password] = gets.chomp
      response = Unirest.post("http://localhost:3000/user_token", parameters: {auth: params})
      jwt = response.body["jwt"]
      Unirest.default_header("Authorization", "Bearer #{jwt}")

    elsif usermenu_selection == 3
      jwt = ""
      Unirest.clear_default_headers()
    end

  # Single Book Option  
  elsif input_main_option == 1

    input_book_option = prompt.select("\nSelect a Book to see more details", compile_book_menu)
    response = Unirest.get("#{$base_url}books/#{input_book_option}")
    book = response.body
    show_single_book(book)

  # All Books Option
  elsif input_main_option == 2
    ab_options = {
      "View all books" => 1,
      "Search by book title" => 2,
      "View all books sorted by price" => 3
    }
    input_ab_menu_option = prompt.select("\nALL BOOKS MENU", ab_options)

    # Show all books
    if input_ab_menu_option == 1
      response = Unirest.get("#{$base_url}books")
      books = response.body
      books.each do |indiv|
        puts
        puts indiv["title"]
        puts indiv["author"]
        puts "Number of pages: #{indiv["pages"]}"
      end
    # Search by title
    elsif input_ab_menu_option == 2
      print "Search by book title: "
      search_title_terms = gets.chomp
      response = Unirest.get("#{$base_url}books?search=#{search_title_terms}")
      books = response.body
      books.each do |indiv|
        puts
        puts indiv["title"]
        puts indiv["author"]
        puts "Number of pages: #{indiv["pages"]}"
      end
    # Sort by price
    elsif input_ab_menu_option == 3
      response = Unirest.get("#{$base_url}books?sort_by_price=true")
      books = response.body
      books.each do |indiv|
        puts
        puts indiv["title"]
        puts indiv["author"]
        puts "Book price: #{indiv["price"]}"
      end
    end

  # Create Book
  elsif input_main_option == 3
    params = {}
    print "Please enter a book title: "
    params[:title] = gets.chomp
    print "Please enter the author of the book: "
    params[:author] = gets.chomp
    print "Please enter a book price: "
    params[:price] = gets.chomp
    print "Please enter the number of pages in the book: "
    params[:pages] = gets.chomp
    response = Unirest.post("#{$base_url}books", parameters: params)
    book = response.body
    if book["errors"]
      puts "\nDID NOT SAVE. INVALID ENTRY:"
      puts book["errors"]
    else
      puts "\nYou've added a book!"
      sleep 0.75
      show_single_book(book)
    end

  # Update Book
  elsif input_main_option == 4

    input_book_option = prompt.select("\nSelect the book you would like to update", compile_book_menu)
    response = Unirest.get("#{$base_url}books/#{input_book_option}")
    book = response.body

    # Book Update Features Loop
    params = {}
    while true
      show_single_book(book)
      att_options = ["Title", "Author", "Price", "Num Pages", "Apply Changes", "Return to Menu (does not apply changes)"]
      att_selection = prompt.select("\nSelect an attribute you would like to update", att_options)

      if att_selection == "Title"
        print "Please update the book title: "
        params[:title] = gets.chomp
        book["title"] = params[:title]
      elsif att_selection == "Author"
        print "Please update the author of the book: "
        params[:author] = gets.chomp
        book["author"] = params[:author]
      elsif att_selection == "Price"
        print "Please update the book price: "
        params[:price] = gets.chomp
        book["price"] = params[:price]
      elsif att_selection == "Num Pages"
        print "Please update the number of pages in the book: "
        params[:pages] = gets.chomp
        book["pages"] = params[:pages]
      elsif att_selection == "Apply Changes"
        break
      elsif att_selection == "Return to Menu (does not apply changes)"
        break
      end
    end

    if att_selection == "Return to Menu (does not apply changes)"
    else
      params.delete_if { |_key, value| value.empty? }
      response = Unirest.patch("#{$base_url}books/#{input_book_option}", parameters: params)
      book = response.body
      if book["errors"]
        puts "\nDID NOT SAVE. INVALID ENTRY:"
        puts book["errors"]
      else
        puts "\nChanges Applied"
        sleep 0.5
        show_single_book(book)
      end
    end

    # Delete a Book
  elsif input_main_option == 5

    input_book_option = prompt.select("\nSelect the book you would like to delete", compile_book_menu)
    response = Unirest.get("#{$base_url}books/#{input_book_option}")
    book = response.body
    show_single_book(book)

    puts "\nAre you sure you want to delete this book?"
    puts "Type 'yes' to confirm, anything else to return to menu"
    final_delete = gets.chomp
    if final_delete == "yes"
      response = Unirest.delete("#{$base_url}books/#{input_book_option}")
      book = response.body
      puts "\nBook deleted."
      sleep 0.5
      puts "\nReturning to Main Menu..."
      sleep 0.5
    end
  end
  print "\nPress enter to return to Main Menu"
  gets.chomp
end