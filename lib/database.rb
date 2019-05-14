module Database
  @database = {
    advocates: [],
    advocate_ids: [],
    practising_states: []
  }

  def self.get
    return @database
  end

  def self.set new_db
    @database = new_db
  end
end