require_relative '../../lib/result'

RSpec.describe Result do
  context 'Result::Success' do
    subject { Result::Success.new('1UP') }
    describe '#value' do
      it 'returns value' do
        expect(subject.value).to eq '1UP'
      end
    end

    describe '#success?' do
      it { expect(subject.success?).to eq true }
    end

    describe '#failure?' do
      it { expect(subject.failure?).to eq false }
    end
  end

  context 'Result::Failure' do
    subject { Result::Failure.new('1UP') }
    describe '#value' do
      it 'returns value' do
        expect(subject.value).to eq '1UP'
      end
    end

    describe '#success?' do
      it { expect(subject.success?).to eq false }
    end

    describe '#failure?' do
      it { expect(subject.failure?).to eq true }
    end
  end

  context 'Result::Concern' do
    subject do
      Class.new do
        include Result::Concern
      end.new
    end

    describe '#success' do
      it { expect(subject.success('1UP')).to be_a Result::Success }
    end

    describe '#failure' do
      it { expect(subject.failure('1UP')).to be_a Result::Failure }
    end
  end
end
