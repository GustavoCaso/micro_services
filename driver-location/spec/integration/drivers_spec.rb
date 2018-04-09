# frozen_string_literal: true

require 'spec_integration'

RSpec.describe 'Drivers endpoint' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:failure_result) { double('Result::Failure', success?: false, failure?: true, value: 'Error') }
  let(:success_result) { double('Result::Success', success?: true, failure?: false, value: {}) }

  context 'when service return valid result' do
    it 'returns response' do
      expect(Services::Redis::CoordinatesQuery).to receive_message_chain(:new, :call).
        with('678').and_return(success_result)
      get '/drivers/678/locations'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('{}')
      expect(last_response.status).to eq 200
    end
  end

  context 'when service return invalid result' do
    it 'returns response' do
      expect(Services::Redis::CoordinatesQuery).to receive_message_chain(:new, :call).
        with('678').and_return(failure_result)
      get '/drivers/678/locations'
      expect(last_response).to_not be_ok
      expect(last_response.body).to eq('')
      expect(last_response.status).to eq 500
    end
  end
end

