require_relative '../../../../lib/services/distance/comparator'
require_relative '../../../../lib/result'

RSpec.describe Services::Distance::Comparator do
  subject { described_class }

  context 'when two coordinates provided' do
    it 'returns the distance between the two coordinates in meters' do
      madrid = { 'latitude' => 40.4165, 'longitude' => -3.7026 }
      paris = { 'latitude' => 48.8534, 'longitude' => -2.3488 }
      result = described_class.call(madrid, paris)
      expect(result).to be_a(Result::Success)
      expect(result.value).to eq(944193.1347543802)
    end

    it 'use example from stack overflow' do
      a = { 'latitude' => 46.3625, 'longitude' => 15.114444 }
      b = { 'latitude' => 46.055556, 'longitude' => 14.508333 }
      result = described_class.call(a, b)
      expect(result).to be_a(Result::Success)
      expect(result.value).to eq(57794.355108740354)
    end

    it 'using distance less than 500 meters' do
      home = {'latitude' => 40.6826596, 'longitude' => -3.6151842}
      next_house = {'latitude' => 40.6825105, 'longitude' => -3.6170551}
      result = described_class.call(home, next_house)
      expect(result).to be_a(Result::Success)
      expect(result.value).to eq(158.62816255944517)
    end
  end

  context 'when any of the two coordinates is missing' do
    it 'returns failure object' do
      madrid = { 'latitude' => 40.4165 }
      paris = { 'latitude' => 48.8534, 'longitude' => -2.3488 }
      result = described_class.call(madrid, paris)
      expect(result).to be_a(Result::Failure)
      expect(result.value).to eq('Missing Coordinates')
    end
  end

  context 'when nil is passed' do
    it 'returns failure object' do
      madrid = nil
      paris = { 'latitude' => 48.8534, 'longitude' => -2.3488 }
      result = described_class.call(madrid, paris)
      expect(result).to be_a(Result::Failure)
      expect(result.value).to eq('Missing Coordinates')
    end
  end

  context 'when non hash value is passed' do
    it 'returns failure object' do
      madrid = []
      paris = { 'latitude' => 48.8534, 'longitude' => -2.3488 }
      result = described_class.call(madrid, paris)
      expect(result).to be_a(Result::Failure)
      expect(result.value).to eq('Missing Coordinates')
    end
  end
end
