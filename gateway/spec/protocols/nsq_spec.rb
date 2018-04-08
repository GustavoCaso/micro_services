require_relative '../../lib/protocols'

RSpec.describe Protocols::Nsq do
  let(:nsq) { double('Protocols::Nsq::Locations', call: '') }
  subject { described_class.new(params) }

  context 'when topic is locations' do
    let(:params) { { 'topic' => 'locations' } }

    it 'triggers Locations' do
      expect(Protocols::Nsq::Locations).to receive(:new).with({}).and_return(nsq)
      subject.call({})
    end
  end
end
