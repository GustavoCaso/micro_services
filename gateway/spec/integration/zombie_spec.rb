# frozen_string_literal: true
require 'spec_integration'

RSpec.describe 'Zombie driver endpoint' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'when request is successful' do
    before do
      stub_request(:get, "http://localhost:4001/drivers/678").
        with(headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Ruby'
        }).
        to_return(status: 200, body: '{"success":true}', headers: {})
    end

    it 'returns the right response' do
      get '/drivers/678'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('{"success":true}')
      expect(last_response.status).to eq 200
    end
  end

  context 'when request is successful but some json parse issue happens' do
    before do
      stub_request(:get, "http://localhost:4001/drivers/678").
        with(headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Ruby'
        }).
        to_return(status: 200, body: 'error', headers: {})
    end

    it 'returns the right response' do
      get '/drivers/678'
      expect(last_response).to_not be_ok
      expect(last_response.body).to eq('{}')
      expect(last_response.status).to eq 500
    end
  end

  context 'when request is not successful' do
    before do
      stub_request(:get, "http://localhost:4001/drivers/678").
        with(headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Ruby'
        }).
        to_return(status: 500, body: '', headers: {})
    end

    it 'returns the right response' do
      get '/drivers/678'
      expect(last_response).to_not be_ok
      expect(last_response.body).to eq('{}')
      expect(last_response.status).to eq 500
    end
  end
end

