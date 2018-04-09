require 'spec_integration'

RSpec.describe 'Drivers endpoint' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:failure_result) { double('Result::Failure', success?: false, failure?: true, value: 'Error') }
  let(:success_result_zombie) { double('Result::Success', success?: true, failure?: false, value: 498) }
  let(:success_result_not_zombie) { double('Result::Success', success?: true, failure?: false, value: 1000.7877) }

  context 'when everything works as expected' do
    it "triggers Services::Distance" do
      expect(Services::Distance).to receive_message_chain(:new, :call).with('678').and_return(success_result_zombie)
      get '/drivers/678'
    end

    it "returns correct response" do
      expect(Services::Distance).to receive_message_chain(:new, :call).with('678').and_return(success_result_zombie)
      get '/drivers/678'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('{"id":"678","zombie":true}')
    end

    it "returns correct response when is not zombie" do
      expect(Services::Distance).to receive_message_chain(:new, :call).with('678').and_return(success_result_not_zombie)
      get '/drivers/678'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('{"id":"678","zombie":false}')
    end
  end

  context 'when something fails' do
    it "triggers Services::Distance" do
      expect(Services::Distance).to receive_message_chain(:new, :call).with('678').and_return(failure_result)
      get '/drivers/678'
      expect(last_response).to_not be_ok
      expect(last_response.body).to eq('{}')
    end
  end
end
