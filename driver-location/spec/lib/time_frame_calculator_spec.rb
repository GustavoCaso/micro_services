require_relative '../../lib/services/time_frame_calculator'

RSpec.describe Services::TimeFrameCalculator do
  subject { described_class.call }

  before do
    # The time in Epoch for 2018 is 1514761200
    # So minus 5 minutes will alwas be the same result 1514760900
    expect(Time).to receive(:now).and_return(Time.new(2018))
  end

  it 'returns the min and max' do
    min, max = subject
    expect(min).to eq 1514760900
    expect(max).to eq 1514761200
  end
end
