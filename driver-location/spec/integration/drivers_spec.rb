# frozen_string_literal: true

require 'spec_integration'

RSpec.describe 'Drivers endpoint' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def id
    @id ||= 'testing:drivers:endpoint:2'
  end

  context 'when service return valid result' do
    before(:each) do
      expect_any_instance_of(Services::TimeFrameCalculator).to receive(:call).and_return([1,2])
      key = Services::Redis::Keys::COORDINATES.call(id)
      coordinates = { longitude: 1, latitude: 2 }
      REDIS.zadd(key, 1, coordinates.to_json)
    end

    after(:each) do
      key = Services::Redis::Keys::COORDINATES.call(id)
      REDIS.zremrangebyscore(key, 1, 2)
    end

    it 'returns response' do
      get "/drivers/#{id}/locations"
      expect(last_response).to be_ok
      expect(last_response.body).to eq("[{\"longitude\":1,\"latitude\":2}]")
      expect(last_response.status).to eq 200
    end
  end

  context 'when service return invalid result due to JSON parse error' do
    before(:each) do
      expect_any_instance_of(Services::TimeFrameCalculator).to receive(:call).and_return([1,2])
      key = Services::Redis::Keys::COORDINATES.call(id)
      REDIS.zadd(key, 1, 'error')
    end

    after(:each) do
      key = Services::Redis::Keys::COORDINATES.call(id)
      REDIS.zremrangebyscore(key, 1, 2)
    end

    it 'returns response' do
      get "/drivers/#{id}/locations"
      expect(last_response).to_not be_ok
      expect(last_response.body).to eq('')
      expect(last_response.status).to eq 500
    end
  end
end

