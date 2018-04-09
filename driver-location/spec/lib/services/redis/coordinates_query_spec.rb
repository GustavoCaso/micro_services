require_relative '../../../../lib/services/redis/keys'
require_relative '../../../../lib/services/redis/coordinates_query'

RSpec.describe Services::Redis::CoordinatesQuery do
  let(:mock_redis) { double('REDIS').as_null_object }
  let(:mock_time_frame) { double('TimeFrameCalculator', call: [1,2]) }
  subject { described_class.new(redis: mock_redis, time_frame_calculator: mock_time_frame ) }

  context 'when pass an id' do
    let(:id) { 1 }

    it 'gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to receive(:call).with(id)
      subject.call(id)
    end

    it 'calculates the time frame' do
      expect(mock_time_frame).to receive(:call)
      subject.call(id)
    end

    it 'executes query against REDIS' do
      expect(mock_redis).to receive(:zrangebyscore).with('drivers:coordinates:1', 1, 2)
      subject.call(id)
    end

    it 'parses all results from REDIS' do
      redis_response = [
        "{\"longitude\":\"1\",\"latitude\":\"2\",\"updated_at\":\"2018-04-08 17:57:42 +0200\"}",
        "{\"longitude\":\"1\",\"latitude\":\"2\",\"updated_at\":\"2018-04-08 17:57:43 +0200\"}"
      ]
      expected_result = redis_response.map { |r| JSON.parse(r) }
      allow(mock_redis).to receive(:zrangebyscore).and_return(redis_response)
      result = subject.call(id)
      expect(result).to be_a Result::Success
      expect(result.value).to eq(expected_result)
    end
  end

  context 'when no id is passed' do
    let(:id) { nil }

    it 'returns Result::failure' do
      result = subject.call(id)
      expect(result).to be_a Result::Failure
    end

    it 'does not get the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to_not receive(:call)
      subject.call(id)
    end

    it 'does not calculates the time frame' do
      expect(mock_time_frame).to_not receive(:call)
      subject.call(id)
    end

    it 'does not executes query' do
      expect(mock_redis).to_not receive(:zrangebyscore)
      subject.call(id)
    end
  end
end
