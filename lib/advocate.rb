class Advocate
  class << self
    def create type
      if type == :senior
        database = Database.get()
        advocate_id = 0
        loop do
          print "Add an advocate: "
          STDOUT.flush()
          advocate_id = gets.chomp.to_i
          if database[:advocate_ids].include?(advocate_id)
            puts "Please enter an unique advocate ID"
          else
            database[:advocate_ids] << advocate_id
            break
          end
        end
        database[:advocates] << {
          id: advocate_id,
          juniors: [],
          practising_states: [],
          cases: {
            practising: [],
            rejected: []
          }
        }
        Database.set(database)
        puts "Advocate added #{advocate_id}"
      else
        database = Database.get()
        if database[:advocates].empty?
          puts "No senior advocates"
          return
        end
        senior_advocate = {}
        loop do
          print "Senior Advocate ID: "
          STDOUT.flush()
          senior_advocate_id = gets.chomp.to_i
          senior_advocate = search_senior_advocate(senior_advocate_id)
          if senior_advocate.nil?
            puts "#{senior_advocate_id} not found. Please enter proper advocate ID"
          else
            break
          end
        end
        junior_id = 0
        loop do
          print "Junior ID: "
          STDOUT.flush()
          junior_id = gets.chomp.to_i
          if database[:advocate_ids].include?(junior_id)
            puts "Please enter an unique advocate ID"
          else
            database[:advocate_ids] << junior_id
            break
          end
        end
        database[:advocates].select{ |a| a[:id] == senior_advocate[:id] }.first[:juniors] << {
          id: junior_id,
          practising_states: [],
          cases: []
        }
        Database.set(database)
        puts "Advocate added #{junior_id} under #{senior_advocate[:id]}"
      end
    end

    def search_senior_advocate(advocate_id)
      database = Database.get()
      database[:advocates].select{ |a| a[:id] == advocate_id }.first
    end
  end
end