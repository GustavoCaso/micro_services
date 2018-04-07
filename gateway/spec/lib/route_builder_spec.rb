require_relative '../../lib/route_builder'

RSpec.describe RouteBuilder do
  let(:app) { double('App', get: '') }
  subject { described_class.new(app) }

  context 'when valid arguments' do
    let(:url_hash) do
      {
        "path"=>"/drivers/:id",
        "method"=>"GET",
        "http"=>{"host"=>"zombie-driver"}
      }
    end

    it 'creates the right endpoint with the right method and path' do
      expect(app).to receive(:get).with('/drivers/:id')
      subject.call(url_hash)
    end

    it 'creates the right protocol builder' do
      expect(Protocols::Http).to receive(:new).with({"host"=>"zombie-driver"})
      subject.call(url_hash)
    end
  end

  context 'when any of the keys are missing it will not do anything' do
    let(:url_hash) do
      {
        "method"=>"GET",
        "http"=>{"host"=>"zombie-driver"}
      }
    end

    it 'do not creates a new endpoint' do
      expect(app).to_not receive(:get)
      subject.call(url_hash)
    end
  end
end
