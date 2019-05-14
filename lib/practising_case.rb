# Class to take practising cases

class PractisingCase
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
        puts "#{advocate_id} not found. Please enter a proper advocate ID"
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
    case_id = 0
    loop do
      print "Case ID: "
      STDOUT.flush()
      case_id = gets.chomp.to_i
      if type == :senior
        if senior_advocate[:cases][:practising].select{ |c| c[:id] == case_id }.any?
          puts "Please enter an unique case"
        elsif senior_advocate[:cases][:rejected].select{ |c| c[:id] == case_id }.any?
          puts "Please enter a not rejected case"
        else
          break
        end
      elsif type == :junior
        if junior_advocate[:cases].select{ |c| c[:id] == case_id }.any?
          puts "Please enter an unique case"
        else
          break
        end
      end
    end
    prac_state = ''
    loop do
      print "Practising State: "
      STDOUT.flush()
      prac_state = gets.chomp
      if type == :senior && !senior_advocate[:practising_states].include?(prac_state)
        puts "#{prac_state} not found. Please enter a proper practising state"
      elsif type == :junior && !junior_advocate[:practising_states].include?(prac_state)
        puts "#{prac_state} not found. Please enter a proper practising state"
      else
        break
      end
    end
    if senior_advocate[:cases][:rejected].select{ |c| c[:id] == case_id && c[:practising_state] == prac_state }.any?
      puts "Cannot add #{case_id} under #{junior_advocate[:id]}"
      return
    end
    case_detail = { id: case_id, practising_state: prac_state }
    if type == :senior
      database[:advocates].select{ |a| a[:id] == advocate_id }.first[:cases][:practising] << case_detail
    elsif type == :junior
      database[:advocates].select{ |a| a[:id] == senior_advocate[:id] }.first[:juniors].select{ |ja| ja[:id] == advocate_id }.first[:cases] << case_detail
    end
    Database.set(database)
  end
end