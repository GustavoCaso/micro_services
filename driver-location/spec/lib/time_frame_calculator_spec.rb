require_relative '../../lib/services/time_frame_calculator'

RSpec.describe Services::TimeFrameCalculator do
  subject { described_class.new }

  before do
    # The time in Epoch for 2018 is 1514761200
    # So minus 5 minutes will alwas be the same result 1514760900
    expect(Time).to receive(:now).and_return(Time.new(2018))
  end

  context 'when no valid keys are pass' do
    let(:params) { {} }

    it 'returns the min and max' do
      min, max = subject.call(params)
      expect(min).to eq 1514760900
      expect(max).to eq 1514761200
    end
  end

  context 'when valid params are passed' do
    let(:params) { {'minutes' => 10 } }

    it 'returns the min and max' do
      min, max = subject.call(params)
      expect(min).to eq 1514760600 # 1514761200 - 600
      expect(max).to eq 1514761200
    end
  end

  context 'accumulate value when passed multiple params' do
    let(:params) { {'minutes' => 10, 'hours' => 1 } }

    it 'returns the min and max' do
      min, max = subject.call(params)
      expect(min).to eq 1514757000 # 1514761200 - 4200
      expect(max).to eq 1514761200
    end
  end
end
