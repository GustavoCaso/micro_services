require_relative '../../../lib/services/redis/keys'

RSpec.describe Services::Redis::Keys do
  context 'COORDINATES' do
    it 'returns the right key' do
      expect(described_class::COORDINATES.call(1)).to eq 'drivers:coordinates:1'
    end

    it 'returns the right key' do
      expect(described_class::COORDINATES.call(nil)).to eq 'drivers:coordinates:'
    end
  end
end
