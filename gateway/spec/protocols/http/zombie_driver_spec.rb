require_relative '../../../lib/protocols/http/zombie_driver'

RSpec.describe Protocols::Http::ZombieDriver do
  let(:http_client) { double('Http Client') }
  let(:failure_result) { double('Result', success?: false, failure?: true, value: 'Error') }
  let(:success_result) { double('Http Client', success?: true, failure?: false, value: '{}') }
  let(:id) { 345 }
  let(:params) { { id: id } }
  subject { described_class.new(http_client: http_client) }

  context 'when request return a 200' do
    it 'triggers correct request' do
      expect(http_client).to receive(:get).with("http://localhost:4001/drivers/#{id}").and_return(success_result)
      subject.call(params)
    end

    it 'parse the result' do
      allow(http_client).to receive(:get).with("http://localhost:4001/drivers/#{id}").and_return(success_result)
      expect(JSON).to receive(:parse).with('{}')
      subject.call(params)
    end
  end

  context 'when request return a non 200' do
    it 'returns default response' do
      allow(http_client).to receive(:get).with("http://localhost:4001/drivers/#{id}").and_return(failure_result)
      result = subject.call(params)
      expect(result).to eq '{}'
    end
  end

  context 'when no drivers id is found on the params' do
    let(:params) { {} }

    it 'returns default response' do
      result = subject.call(params)
      expect(result).to eq '{}'
    end
  end
end
