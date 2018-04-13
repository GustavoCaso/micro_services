require_relative '../../../../lib/services/redis'
require_relative '../../../../lib/services/redis/keys'
require_relative '../../../../lib/services/redis/coordinates_writer'

RSpec.describe Services::Redis::CoordinatesWriter do
  subject { described_class.new }

  def id
    @id ||= 'testing:coordinates_writer:2'
  end

  def key
    @key ||= Services::Redis::Keys::COORDINATES.call(id)
  end

  context 'when message has all the necessary data' do
    let(:message) do
      {
        'id' => id,
        'longitude' => '156.890',
        'latitude' => '56.768'
      }
    end
    let(:updated_at) { Time.new(2018) } # The time in Epoch for 2018 is 1514761200

    after do
      REDIS.zremrangebyscore(key, 1514761200, 1514761201)
    end

    it 'stores the information with the valid score and message' do
      subject.call(message, updated_at)
      redis_result = REDIS.zrangebyscore(key, 1514761200, 1514761201)
      expected_result = [
        '{"longitude":"156.890","latitude":"56.768","updated_at":"2018-01-01 00:00:00 +0100"}'
      ]
      expect(redis_result).to eq(expected_result)
    end
  end

  context 'when message miss any of the keys' do
    let(:message) do
      {
        'id' => '1'
      }
    end
    let(:updated_at) { Time.new(2018) } # The time in Epoch for 2018 is 1514761200

    it 'does not gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to_not receive(:call)
      subject.call(message, updated_at)
    end

    it 'does not stores the information' do
      expect(REDIS).to_not receive(:zadd)
      subject.call(message, updated_at)
    end
  end

  context 'when message has all the keys but updated_at is not a Time instance' do
    let(:message) do
      {
        'id' => '1',
        'longitude' => '156.890',
        'latitude' => '56.768'
      }
    end
    let(:updated_at) { 'hello world' }

    it 'does not gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to_not receive(:call)
      subject.call(message, updated_at)
    end

    it 'does not stores the information' do
      expect(REDIS).to_not receive(:zadd)
      subject.call(message, updated_at)
    end
  end

  context 'when message has invalid coordinates' do
    let(:message) do
      {
        'id' => '1',
        'longitude' => '200.879',
        'latitude' => '56.768'
      }
    end
    let(:updated_at) { Time.new(2018) } # The time in Epoch for 2018 is 1514761200

    it 'does not gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to_not receive(:call)
      subject.call(message, updated_at)
    end

    it 'does not stores the information' do
      expect(REDIS).to_not receive(:zadd)
      subject.call(message, updated_at)
    end
  end
end
