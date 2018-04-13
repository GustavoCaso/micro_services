require_relative '../../../lib/protocols/http/hosts'

RSpec.describe Protocols::Http::Hosts do
  let(:hosts) do
    {
      'a' => 'hello/world',
      'b' => 'hello/world/{id}',
      'c' => 'hello/world/{id}/where/{location}'
    }
  end

  subject { described_class.new(hosts: hosts) }

  describe '#match' do
    context 'when no subtituion is need it' do
      it 'returns the right url' do
        expect(subject.match('a')).to eq 'hello/world'
      end

      it 'retruns the right url even when params are passed' do
        expect(subject.match('a', {'id' => '5'})).to eq 'hello/world'
      end
    end

    context 'when subtituion is need it' do
      it 'returns the right url' do
        expect(subject.match('b', {'id' => '5'})).to eq 'hello/world/5'
      end

      it 'retruns nil if the url have matches that are not replaced' do
        expect(subject.match('b', {'fake' => '5'})).to eq nil
      end
    end

    context 'when multiple arguments needs to be subtitude' do
      it 'returns the right url' do
        expect(subject.match('c', {'id' => '5', 'location' => 'madrid'})).to eq 'hello/world/5/where/madrid'
      end

      it 'retruns nil if the url have matches that are not replaced' do
        expect(subject.match('c', {'id' => '5', 'place' => 'madrid'})).to eq nil
      end
    end

    context 'when no host is register with that key' do
      it 'returns nil' do
        expect(subject.match('d')).to eq nil
      end
    end
  end
end
