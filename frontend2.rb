require "unirest"
require "tty-prompt"
require "tty-table"

$base_url = "http://localhost:3000/v1/"

class Frontend

  def initialize
    @prompt = TTY::Prompt.new

    # Auto Login
    params = {email: "john@email.com", password: "john"}
    response = Unirest.post("http://localhost:3000/user_token", parameters: {auth: params})
    jwt = response.body["jwt"]
    if jwt == nil
      puts "\nFailed to login. Please try again."
    else
      puts "\nLogin successful"
    end
    Unirest.default_header("Authorization", "Bearer #{jwt}")

    response = Unirest.get("#{$base_url}/current_user")
    user = response.body
    if user["admin"]
      @mm_options = {
        "View a Book" => -> do single_book_options end, 
        "View all Books" => -> do show_all_books end,
        "Add a Book" => -> do create_book end,
        "Update a Book" => -> do update_book end,
        "Remove a Book" => -> do delete_book end,
        "View your Order(s)" => -> do view_orders end,
        "User Menu" => -> do user_menu end,
        "Exit" => -> do quit end
      }
    else
      @mm_options = {
        "View a Book" => -> do single_book_options end, 
        "View all Books" => -> do show_all_books end,
        "View your Order(s)" => -> do view_orders end,
        "User Menu" => -> do user_menu end,
        "Exit" => -> do quit end
      }
    end
  end
  
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

  def single_book_options
    input_book_option = @prompt.select("\nSelect a Book to see more details", compile_book_menu)
    response = Unirest.get("#{$base_url}books/#{input_book_option}")
    book = response.body
    if response.code == 400
      puts "\nPlease Login to View"
    else 
      show_single_book(book)
      print "\nWould you like to order this book? (y/n): "
      input_order = gets.chomp
      if input_order == "y"
        print "Enter a quantity to order: "
        input_order_quantity = gets.chomp.to_i
        response = Unirest.post("#{$base_url}orders", parameters: {
          book_id: book["id"],
          quantity: input_order_quantity,
          price: book["price"],
          tax: book["tax"],
          total: book["price_with_tax"]
        }
      )
        puts response.body
      elsif input_order == "n"
      end
    end
  end

  def show_all_books
    ab_options = {
          "View all books" => 1,
          "Search by book title" => 2,
          "View all books sorted by price" => 3
        }
    input_ab_menu_option = @prompt.select("\nALL BOOKS MENU", ab_options)

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
  end

  def create_book
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
  end

  def update_book
    input_book_option = @prompt.select("\nSelect the book you would like to update", compile_book_menu)
    response = Unirest.get("#{$base_url}books/#{input_book_option}")
    book = response.body

    # Book Update Features Loop
    params = {}
    while true
      show_single_book(book)
      att_options = ["Title", "Author", "Price", "Num Pages", "Apply Changes", "Return to Menu (does not apply changes)"]
      att_selection = @prompt.select("\nSelect an attribute you would like to update", att_options)

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
  end

  def delete_book
    input_book_option = @prompt.select("\nSelect the book you would like to delete", compile_book_menu)
    response = Unirest.get("#{$base_url}books/#{input_book_option}")
    book = response.body
    show_single_book(book)

    puts "\nAre you sure you want to delete this book?"
    puts "Type 'yes' to confirm, anything else to return to menu"
    final_delete = gets.chomp
    if final_delete == "yes"
      response = Unirest.delete("#{$base_url}books/#{input_book_option}")
      book = response.body
      if book["errors"]
        puts "\nDID NOT SAVE. INVALID ENTRY:"
        puts book["errors"]
      else 
        puts "\nBook deleted."
        sleep 0.5
        puts "\nReturning to Main Menu..."
        sleep 0.5
      end
    end
  end

  def view_orders
    response = Unirest.get("#{$base_url}orders")
    orders = response.body
    orders.each do |order|
      response = Unirest.get("#{$base_url}books/#{order["book_id"]}")
      book = response.body
      puts "Title: #{book["title"]} - Qty Ordered: #{order["quantity"]} - Total: #{order["total"]}"
    end
  end

  def user_menu
    usermenu_options = {
      "Create User" => 1,
      "Login" => 2,
      "Logout" => 3,
      "Delete User" => 4,
      "Back to Main Menu" => 5
    }
    usermenu_selection = @prompt.select("\nUSER MENU", usermenu_options)

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
      if jwt == nil
        puts "\nFailed to login. Please try again."
      else
        puts "\nLogin successful"
      end
      Unirest.default_header("Authorization", "Bearer #{jwt}")

    # Logout
    elsif usermenu_selection == 3
      jwt = ""
      Unirest.clear_default_headers()
    end
  end

  def quit
    puts "\nGoodbye"
    exit
  end

  def run
    while true
      @prompt.select("\n@----- MAIN MENU -----@", @mm_options)

      print "\nPress enter to return to Main Menu"
      gets.chomp
    end
  end
end

frontend = Frontend.new
frontend.run