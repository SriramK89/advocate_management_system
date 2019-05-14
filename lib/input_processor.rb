# Input processing and final output displaying class

class InputProcessor
  def self.get input_choice
    case input_choice
    when 1
      Advocate.create(:senior)
    when 2
      Advocate.create(:junior)
    when 3
      PractisingState.create()
    when 4
      PractisingCase.create()
    when 5
      RejectedCase.create()
    when 7
      DisplayData.state_wise_cases()
    end

    DisplayData.all() if input_choice <= 6 && Database.get()[:advocates].any?
  end
end