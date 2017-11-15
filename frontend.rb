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
  end
end