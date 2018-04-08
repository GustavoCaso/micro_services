require_relative '../../../lib/protocols/nsq/locations'

RSpec.describe Protocols::Nsq::Locations do
  let(:nsq_producer) { double('Nsq::Producer').as_null_object }
  let(:params) { { longitude: 1, latitude: 2, id: 3 } }
  subject { described_class.new(params, producer: nsq_producer) }

  context 'when params have all attributes' do
    it 'instanciates a new producer' do
      expect(nsq_producer).to receive(:new).with(nsqd: described_class::NSQD, topic: described_class::TOPIC_NAME)
      subject.call
    end

    it 'writes a new message to the topic' do
      message = { driver: 3, coordinates: { longitude: 1, latitude: 2 } }.to_json
      expect(nsq_producer).to receive(:write).with(message)
      subject.call
    end

    it 'terminates the producer after writing' do
      expect(nsq_producer).to receive(:terminate)
      subject.call
    end
  end

  context 'when any of the params is missing' do
    let(:params) { { longitude: 1, id: 3 } }

    it 'does not instanciate a new producer' do
      expect(nsq_producer).to_not receive(:new)
      subject.call
    end

    it 'writes a new message to the topic' do
      expect(nsq_producer).to_not receive(:write)
      subject.call
    end

    it 'terminates the producer after writing' do
      expect(nsq_producer).to_not receive(:terminate)
      subject.call
    end
  end
end
