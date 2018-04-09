require_relative '../../../lib/services/listener'

RSpec.describe Services::Listener do
  let(:nsq_consumer) { double('NSQ::Consumer').as_null_object }
  let(:writer) { double('Services::Redis::CoordinatesWriter').as_null_object }
  let(:timestamp) { Time.new(2018) }
  let(:message) { double('Message', body: '{}', timestamp: timestamp, finish: true) }
  subject { described_class.new(nsq_consumer: nsq_consumer, writer: writer) }

  before do
    allow(nsq_consumer).to receive(:pop_without_blocking).and_return(message)
  end

  context 'when there are messages' do
    it 'creates a consumer' do
      expect(nsq_consumer).to receive(:new).with(nsqlookupd: Services::Listener::NSQLOOKUPD,
        topic: Services::Listener::TOPIC,
        channel: Services::Listener::CHANNEL)
      subject.call
    end

    it 'executes writer with right arguments' do
      expect(writer).to receive(:call).with({}, timestamp)
      subject.call
    end

    it 'marks message as finish' do
      expect(message).to receive(:finish)
      subject.call
    end
  end

  context 'when parsing a message fail' do
    before do
      expect(JSON).to receive(:parse).and_raise(JSON::JSONError)
    end

    it 'marks the message as finish' do
      expect(message).to receive(:finish)
      subject.call
    end
  end
end
