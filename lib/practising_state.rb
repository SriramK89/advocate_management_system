# Class to add practising states for an advocate

class PractisingState
  def self.create
    database = Database.get()
    advocate_id = 0
    loop do
      print "Advocate ID: "
      STDOUT.flush()
      advocate_id = gets.chomp.to_i
      if database[:advocate_ids].include?(advocate_id)
        break
      else
        puts "#{advocate_id} not found. Please enter proper advocate ID"
      end
    end
    senior_advocate = {}
    junior_advocate = {}
    type = ''
    database[:advocates].each do |sen_adv|
      found_jun_adv = false
      if sen_adv[:id] == advocate_id
        senior_advocate = sen_adv
        type = :senior
        break
      else
        sen_adv[:juniors].each do |jun_adv|
          if jun_adv[:id] == advocate_id
            senior_advocate = sen_adv
            junior_advocate = jun_adv
            type = :junior
            found_jun_adv = true
          end
        end
      end
      break if found_jun_adv
    end
    prac_state = ''
    loop do
      print "Practising State: "
      STDOUT.flush()
      prac_state = gets.chomp
      if type == :senior && senior_advocate[:practising_states].include?(prac_state)
        puts "Please enter an unique practising state"
      elsif type == :junior && junior_advocate[:practising_states].include?(prac_state)
        puts "Please enter an unique practising state"
      else
        break
      end
    end
    if type == :junior && !senior_advocate[:practising_states].include?(prac_state)
      puts "Cannot add #{prac_state} for #{advocate_id}"
      return
    end
    case type
    when :senior
      database[:advocates].select{ |a| a[:id] == advocate_id }.first[:practising_states] << prac_state
    when :junior
      database[:advocates].select{ |a| a[:id] == senior_advocate[:id] }.first[:juniors].select{ |ja| ja[:id] == advocate_id }.first[:practising_states] << prac_state
    end
    database[:practising_states] = (database[:practising_states] + [prac_state]).uniq
    Database.set(database)
    puts "State added #{prac_state} for #{advocate_id}"
  end
end