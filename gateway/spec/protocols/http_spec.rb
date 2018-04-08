require_relative '../../lib/protocols'

RSpec.describe Protocols::Http do
  subject { described_class.new(params) }

  context 'when host is zombie-driver' do
    let(:params) { { 'host' => 'zombie-driver' } }

    it 'triggers ZombieDriver' do
      expect(Protocols::Http::ZombieDriver).to receive_message_chain(:new, :call).with({})
      subject.call({})
    end
  end
end
