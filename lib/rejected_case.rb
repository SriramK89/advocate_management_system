# Class to reject cases

class RejectedCase
  def self.create
    database = Database.get()
    advocate_id = 0
    loop do
      print "Advocate ID: "
      STDOUT.flush()
      advocate_id = gets.chomp.to_i
      if database[:advocate_ids].include?(advocate_id) && database[:advocates].select{ |a| a[:id] == advocate_id }.any?
        break
      else
        puts "#{advocate_id} not found. Please enter a proper advocate ID"
      end
    end
    advocate = database[:advocates].select{ |a| a[:id] == advocate_id }.first
    case_id = 0
    loop do
      print "Case ID: "
      STDOUT.flush()
      case_id = gets.chomp.to_i
      if advocate[:cases][:practising].select{ |c| c[:id] == case_id }.any?
        puts "Please enter a not practising case"
      elsif advocate[:cases][:rejected].select{ |c| c[:id] == case_id }.any?
        puts "Please enter an unique case"
      else
        break
      end
    end
    prac_state = ''
    loop do
      print "Practising State: "
      STDOUT.flush()
      prac_state = gets.chomp
      if advocate[:practising_states].include?(prac_state)
        break
      else
        puts "#{prac_state} not found. Please enter a proper practising state"
      end
    end
    case_detail = { id: case_id, practising_state: prac_state }
    database[:advocates].select{ |a| a[:id] == advocate_id }.first[:cases][:rejected] << case_detail
    Database.set(database)
    puts "Case #{case_id} is added in Block list for #{advocate_id}"
  end
end