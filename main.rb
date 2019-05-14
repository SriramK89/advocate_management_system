# Starting point of this application

require './lib/database'
require './lib/input_processor'
require './lib/display_data'
require './lib/advocate'
require './lib/practising_state'
require './lib/practising_case'
require './lib/rejected_case'

puts "1. Add an advocate"
puts "2. Add junior advocates"
puts "3. Add states for advocate"
puts "4. Add cases for advocate"
puts "5. Reject a case"
puts "6. Display all advocates"
puts "7. Display all cases under a state"
puts "8. Exit"

input_choice = 0

loop do
  print "Input: "
  STDOUT.flush()
  input_choice = gets.chomp.to_i
  if input_choice < 1 && input_choice > 8
    puts "Please choose an option from 1-8 as given first"
  else
    InputProcessor.get(input_choice)
  end
  break if input_choice == 8
end