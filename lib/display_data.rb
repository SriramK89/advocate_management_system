# Class to display data

class DisplayData
  class << self
    def all
      database = Database.get()
      puts "Display:"
      database[:advocates].each do |advocate|
        puts "Advocate Name: #{advocate[:id]}"
        puts "Practising states: #{advocate[:practising_states].join(', ')}" if advocate[:practising_states].any?
        puts "Practising cases: #{advocate[:cases][:practising].map{ |c| show_case(c) }.join(', ')}" if advocate[:cases][:practising].any?
        puts "BlockList cases: #{advocate[:cases][:rejected].map{ |c| show_case(c) }.join(', ')}" if advocate[:cases][:rejected].any?
        advocate[:juniors].each do |j_advocate|
          puts "-Advocate Name: #{j_advocate[:id]}"
          puts "-Practising states: #{j_advocate[:practising_states].join(', ')}" if j_advocate[:practising_states].any?
          puts "-Practising cases: #{j_advocate[:cases].map{ |c| show_case(c) }.join(', ')}" if j_advocate[:cases].any?
        end
      end
    end

    def state_wise_cases
      database = Database.get()
      database[:practising_states].each do |prac_state|
        puts prac_state
        database[:advocates].each do |advocate|
          if advocate[:practising_states].include?(prac_state)
            swc = advocate[:cases][:practising].select{ |c| c[:practising_state] == prac_state } + advocate[:cases][:rejected].select{ |c| c[:practising_state] == prac_state }
            puts "#{advocate[:id]} - #{swc.map{ |c| c[:id] }.join(', ')}"
            advocate[:juniors].each do |jun_adv|
              if jun_adv[:practising_states].include?(prac_state)
                swc = jun_adv[:cases].select{ |c| c[:practising_state] == prac_state }
                puts "#{jun_adv[:id]} - #{swc.map{ |c| c[:id] }.join(', ')}"
              end
            end
          end
        end
      end
    end

    def show_case case_details
      "#{case_details[:id]}-#{case_details[:practising_state]}"
    end
  end
end