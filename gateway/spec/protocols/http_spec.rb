require 'ostruct'
require_relative '../../lib/protocols/http/hosts'
require_relative '../../lib/protocols'
require_relative '../../lib/result'

RSpec.describe Protocols::Http do
  let(:http_request) { double('HttpRequest') }
  let(:app) { OpenStruct.new(params: {'id' => '5'}) }
  let(:success) { Result::Success.new('{}') }
  let(:failure) { Result::Failure.new('Failed') }
  subject { described_class.new(configuration, http_client: http_request) }

  context 'when host exists' do
    let(:configuration) { { 'host' => 'zombie-driver' } }

    it 'returns right values' do
      expect(http_request).to receive(:get).with('http://localhost:4001/drivers/5').and_return(success)
      result = subject.call(app, ['id'])
      expect(result).to eq([200, '{}'])
    end
  end

  context 'when json parse error happens' do
    let(:configuration) { { 'host' => 'zombie-driver' } }

    it 'returns right values' do
      expect(http_request).to receive(:get).with('http://localhost:4001/drivers/5').and_return(Result::Success.new('error'))
      result = subject.call(app, ['id'])
      expect(result).to eq([500, '{}'])
    end
  end

  context 'when host does not exists' do
    let(:configuration) { { 'host' => 'fake_one' } }

    it 'returns right values' do
      expect(http_request).to receive(:get).with(nil).and_return(failure)
      result = subject.call(app, ['id'])
      expect(result).to eq([500, '{}'])
    end
  end
end
