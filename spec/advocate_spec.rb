require './lib/advocate'
require './lib/database'

describe Advocate do
  it 'creates a senior advocate successfully' do
    senior_advocate_id = 1001
    expect(Database.get()[:advocates].count).to eq(0)
    expect(Advocate).to receive(:print).with("Add an advocate: ")
    allow(Advocate).to receive(:gets).and_return(senior_advocate_id.to_s)
    expect(Advocate).to receive(:puts).with("Advocate added #{senior_advocate_id}")
    Advocate.create(:senior)
    expect(Database.get()[:advocates].count).to eq(1)
    expect(Database.get()[:advocates].first[:id]).to eq(senior_advocate_id)
  end

  it 'creates a junior advocate successfully' do
    senior_advocate_id = 1001
    junior_advocate_id = 100
    expect(Database.get()[:advocates].count).to eq(1)
    expect(Advocate).to receive(:puts).with("Junior ID: ")
    allow(Advocate).to receive(:gets).and_return((junior_advocate_id).to_s)
    expect(Advocate).to receive(:print).with("Senior Advocate ID: ")
    allow(Advocate).to receive(:gets).and_return(senior_advocate_id.to_s)
    expect(Advocate).to receive(:puts).with("Advocate added #{junior_advocate_id} under #{senior_advocate_id}")
    Advocate.create(:junior)
    expect(Database.get()[:advocates].select{ |a| a[:id] == senior_advocate_id }.first[:juniors].first[:id]).to eq(junior_advocate_id)
  end
end