# frozen_string_literal: true

require 'spec_integration'

RSpec.describe 'Locations endpoint' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def nsq_double
    @nsq_double ||= double('NSQ', terminate: true)
  end

  context 'valid JSON' do
    before do
      expect(Nsq::Producer).to receive(:new)
        .with(nsqd: Protocols::Nsq::NSQD, topic: 'locations').and_return(nsq_double)
    end

    it 'writes the message to the queue and returns 200' do
      expect(nsq_double).to receive(:write).with('{"latitude":1,"longitude":3,"id":"678"}')
      body = { latitude: 1, longitude: 3 }.to_json
      patch '/drivers/678/locations', body, 'Content-Type' => 'application/json'
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
    end
  end

  context 'invalid JSON' do
    it 'returns a 500' do
      patch '/drivers/678/locations', 'test', 'Content-Type' => 'application/json'
      expect(last_response).to_not be_ok
      expect(last_response.status).to eq 500
    end
  end
end
