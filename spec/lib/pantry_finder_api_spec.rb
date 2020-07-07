# frozen_string_literal: true

describe PantryFinderApi do
  let(:url) { 'http://test.com' }
  let(:pantry_finder_api) { described_class.new(url: url) }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn) { Faraday.new { |config| config.adapter :test, stubs } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  it 'returns event_date response' do
    stubs.get('api/event_dates/123') do
      [
        200,
        { 'Content-Type' => 'application/json;charset=utf-8' },
        event_date_response
      ]
    end
    response = pantry_finder_api.event_date('123')
    response.should == event_date_response[:event_date]
  end

  it 'returns event_slot response' do
    stubs.get('api/event_slots/1234') do
      [
        200,
        { 'Content-Type' => 'application/json;charset=utf-8' },
        event_slot_response
      ]
    end
    response = pantry_finder_api.event_slot('1234')
    response.should == event_slot_response[:event_slot]
  end

  def event_date_response
    {
      event_date:
      {
        id: 1742, event_id: 1740, capacity: 100,
        accept_walkin: 1, accept_reservations: 0, accept_interest: 1,
        start_time: '3 PM', end_time: '6 PM', date: '2020-07-30'
      }
    }
  end

  def event_slot_response
    {
      event_slot:
      {
        event_slot_id: 7379,
        capacity: 33, start_time: '2 PM',
        end_time: '2:59 PM', open_slots: 33
      }
    }
  end
end