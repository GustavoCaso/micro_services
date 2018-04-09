require_relative '../../../lib/services/distance'

RSpec.describe Services::Distance do
  let(:http_client) { double('Http Client').as_null_object }
  let(:failure_result) { double('Result::Failure', success?: false, failure?: true, value: 'Error') }
  let(:success_result) { double('Result::Success', success?: true, failure?: false, value: '[1,2]') }
  let(:comparator) { double('Comparator') }
  let(:id) { 345 }
  subject { described_class.new(http_request: http_client, comparator: comparator) }

  context 'when request for coordinates is OK' do
    it 'executes get request' do
      expect(http_client).to receive(:get).with('http://localhost:4002/drivers/345/locations')
      subject.call(id)
    end

    it 'executes get comparator with correct arguments' do
      allow(http_client).to receive(:get).with('http://localhost:4002/drivers/345/locations').and_return(success_result)
      expect(comparator).to receive(:call).with(1,2)
      subject.call(id)
    end
  end

  context 'when request for coordinates is not OK' do
    it 'returns Result::Failure object' do
      allow(http_client).to receive(:get).with('http://localhost:4002/drivers/345/locations').and_return(failure_result)
      result = subject.call(id)
      expect(result).to be_a(Result::Failure)
      expect(result.value).to eq('Error')
    end
  end

  context 'parsing raises an error' do
    it 'returns Result::Failure object' do
      allow(JSON).to receive(:parse).and_raise(JSON::JSONError)
      result = subject.call(id)
      expect(result).to be_a(Result::Failure)
    end
  end
end
