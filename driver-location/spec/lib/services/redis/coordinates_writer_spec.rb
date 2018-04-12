require_relative '../../../../lib/services/redis/keys'
require_relative '../../../../lib/services/redis/coordinates_writer'

RSpec.describe Services::Redis::CoordinatesWriter do
  let(:mock_redis) { double('REDIS').as_null_object }
  subject { described_class.new(redis: mock_redis) }

  context 'when message has all the necessary data' do
    let(:message) do
      {
        'driver' => '1',
        'coordinates' => {
          'longitude' => '156.890',
          'latitude' => '56.768'
        }
      }
    end
    let(:updated_at) { Time.new(2018) } # The time in Epoch for 2018 is 1514761200

    it 'gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to receive(:call).with(message['driver'])
      subject.call(message, updated_at)
    end

    it 'stores the information with the valid score and message' do
      key = 'drivers:coordinates:1'
      score = updated_at.to_i
      data = message['coordinates'].merge('updated_at' => updated_at.to_s).to_json
      expect(mock_redis).to receive(:zadd).with(key, score, data)
      subject.call(message, updated_at)
    end
  end

  context 'when message miss any of the keys' do
    let(:message) do
      {
        'driver' => '1',
      }
    end
    let(:updated_at) { Time.new(2018) } # The time in Epoch for 2018 is 1514761200

    it 'does not gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to_not receive(:call)
      subject.call(message, updated_at)
    end

    it 'does not stores the information' do
      expect(mock_redis).to_not receive(:zadd)
      subject.call(message, updated_at)
    end
  end

  context 'when message has all the keys but updated_at is not a Time instance' do
    let(:message) do
      {
        'driver' => '1',
        'coordinates' => {
          'longitude' => '156.890',
          'latitude' => '56.768'
        }
      }
    end
    let(:updated_at) { 'hello world' }

    it 'does not gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to_not receive(:call)
      subject.call(message, updated_at)
    end

    it 'does not stores the information' do
      expect(mock_redis).to_not receive(:zadd)
      subject.call(message, updated_at)
    end
  end

  context 'when message has invalid coordinates' do
    let(:message) do
      {
        'driver' => '1',
        'coordinates' => {
          'longitude' => '200.879',
          'latitude' => '56.768'
        }
      }
    end
    let(:updated_at) { Time.new(2018) } # The time in Epoch for 2018 is 1514761200

    it 'does not gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to_not receive(:call)
      subject.call(message, updated_at)
    end

    it 'does not stores the information' do
      expect(mock_redis).to_not receive(:zadd)
      subject.call(message, updated_at)
    end
  end
end
