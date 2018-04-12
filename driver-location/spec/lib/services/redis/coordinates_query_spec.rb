require_relative '../../../../lib/services/redis/keys'
require_relative '../../../../lib/services/redis/coordinates_query'

RSpec.describe Services::Redis::CoordinatesQuery do
  let(:mock_time_frame) { instance_double('TimeFrameCalculator', call: [1,2]) }
  let(:id) { 'testing:coordinates:query:1' }
  let(:params) { { 'id' => id, 'minutes' => 5 } }
  subject { described_class.new(time_frame_calculator: mock_time_frame ) }

  context 'when pass an id and time arguments' do
    it 'gets the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to receive(:call).with(id)
      subject.call(params)
    end

    it 'calculates the time frame' do
      expect(mock_time_frame).to receive(:call).with('minutes' => 5)
      subject.call(params)
    end
  end

  context 'when there is data in redis' do

    before do
      key = Services::Redis::Keys::COORDINATES.call('testing:coordinates:query:1')
      coordinates_1 = { longitude: 1, latitude: 2 }
      coordinates_2 = { longitude: 2, latitude: 3 }
      REDIS.zadd(key, 1, coordinates_1.to_json)
      REDIS.zadd(key, 2, coordinates_2.to_json)
    end

    after do
      key = Services::Redis::Keys::COORDINATES.call('testing:coordinates:query:1')
      REDIS.zremrangebyscore(key, 1, 2)
    end

    it 'executes query against REDIS' do
      redis_response = [
        "{\"longitude\": 1,\"latitude\": 2 }",
        "{\"longitude\": 2,\"latitude\": 3 }"
      ]
      expected_result = redis_response.map { |r| JSON.parse(r) }
      result = subject.call(params)
      expect(result).to be_a Result::Success
      expect(result.value).to eq(expected_result)
    end
  end

  context 'when no id is passed' do
    let(:params) { {} }

    it 'returns Result::failure' do
      result = subject.call(params)
      expect(result).to be_a Result::Failure
    end

    it 'does not get the valid key' do
      expect(Services::Redis::Keys::COORDINATES).to_not receive(:call)
      subject.call(params)
    end

    it 'does not calculates the time frame' do
      expect(mock_time_frame).to_not receive(:call)
      subject.call(params)
    end

    it 'does not executes query' do
      expect_any_instance_of(Redis).to_not receive(:zrangebyscore)
      subject.call(params)
    end
  end
end
