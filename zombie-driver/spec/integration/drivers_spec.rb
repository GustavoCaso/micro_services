require 'spec_integration'

RSpec.describe 'Drivers endpoint' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'when distance is bigger than 500 meters' do
    before do
      coordinates = '[{"latitude":40.4165,"longitude":-3.7026},{"latitude":48.8534,"longitude":-2.3488}]'
      result = Result::Success.new(coordinates)
      expect_any_instance_of(Services::HttpRequest).to receive(:get).and_return(result)
    end

    it "returns correct response" do
      get '/drivers/678'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('{"id":"678","zombie":false}')
    end
  end

  context 'when distance is smaller than 500 meters' do
    before do
      coordinates = '[{"latitude":40.6826596,"longitude":-3.6151842},{"latitude":40.6825105,"longitude":-3.6170551}]'
      result = Result::Success.new(coordinates)
      expect_any_instance_of(Services::HttpRequest).to receive(:get).and_return(result)
    end

    it 'returns correct response' do
      get '/drivers/678'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('{"id":"678","zombie":true}')
    end
  end

  context 'when request fails' do
    before do
      result = Result::Failure.new('Fail request')
      expect_any_instance_of(Services::HttpRequest).to receive(:get).and_return(result)
    end

    it 'returns correct response' do
      get '/drivers/678'
      expect(last_response).to_not be_ok
      expect(last_response.body).to eq('{}')
    end
  end

  context 'when fails at parsing the response' do
    before do
      result = Result::Success.new('aaa')
      expect_any_instance_of(Services::HttpRequest).to receive(:get).and_return(result)
    end

    it 'returns correct response' do
      get '/drivers/678'
      expect(last_response).to_not be_ok
      expect(last_response.body).to eq('{}')
    end
  end
end
