require_relative '../../../../lib/result'
require_relative '../../../../lib/services/distance/comparator'

RSpec.describe Services::Distance::Comparator do
  subject { described_class.new(coordinates) }

  context 'when one coordinate provided' do
    let(:coordinates) do
      [
        { 'latitude' => 40.4165, 'longitude' => -3.7026 }, # Madrid
      ]
    end
    it 'returns 0' do
      result = subject.call
      expect(result).to be_a(Result::Success)
      expect(result.value).to eq(0)
    end
  end

  context 'when two coordinates provided' do
    let(:coordinates) do
      [
        { 'latitude' => 40.4165, 'longitude' => -3.7026 }, # Madrid
        { 'latitude' => 48.8534, 'longitude' => -2.3488 } # Paris
      ]
    end
    it 'returns the distance between coordinates in meters' do
      result = subject.call
      expect(result).to be_a(Result::Success)
      expect(result.value).to eq(944193.1347543802)
    end
  end

  # https://stackoverflow.com/a/12969617
  context 'use example from stack overflow' do
    let(:coordinates) do
      [
        { 'latitude' => 46.3625, 'longitude' => 15.114444 },
        { 'latitude' => 46.055556, 'longitude' => 14.508333 }
      ]
    end
    it 'returns the distance between coordinates in meters' do
      result = subject.call
      expect(result).to be_a(Result::Success)
      expect(result.value).to eq(57794.355108740354)
    end
  end

  context 'multiple coordinates add to less that 500 meters' do
    let(:coordinates) do
      [
        {'latitude' => 40.6826596, 'longitude' => -3.6151842}, # my house
        {'latitude' => 40.6825105, 'longitude' => -3.6170551}, # next house
        {'latitude' =>40.682621, 'longitude' => -3.614373} # next corner
      ]
    end

    it 'returns the distance between coordinates in meters' do
      result = subject.call
      expect(result).to be_a(Result::Success)
      expect(result.value).to eq(385.12373706516144)
    end
  end

  context 'when one of the coordinates is invalid it will not be use' do
    let(:coordinates) do
      [
        {'latitude' => 40.6826596, 'longitude' => -3.6151842}, # my house
        {'latitude' => 40.6825105 }, # wrong
        {'latitude' => 40.682621, 'longitude' => -3.614373} # next corner
      ]
    end

    it 'returns the distance between coordinates in meters' do
      expect(subject.points).to eq(coordinates)
      latitudes = subject.coordinates.map(&:latitude)
      expect(latitudes).to_not include(40.6825105)
    end
  end

  context 'when nil is passed' do
    let(:coordinates) { nil }

    it 'returns 0' do
      result = subject.call
      expect(result).to be_a(Result::Success)
      expect(result.value).to eq(0)
    end
  end
end
