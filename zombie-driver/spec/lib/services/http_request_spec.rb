require_relative '../../../lib/services/http_request'

RSpec.describe Services::HttpRequest do
  subject { described_class.new }

  describe '#get' do
    context 'when resource found' do
      before do
        stub_request(:get, "http://www.testing.org:443").
         with(  headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Ruby'
           }).
         to_return(status: 200, body: "", headers: {})
      end

      let(:url) { 'https://www.testing.org' }

      it 'returns success object' do
        expect(subject.get(url)).to be_a Result::Success
      end
    end

    context 'when not able to connect to service' do
      before do
        stub_request(:get, "http://www.testing.org:443/boom").to_raise(Errno::ECONNREFUSED)
      end

      let(:url) { 'https://www.testing.org/boom' }

      it 'return returns a failure object' do
        expect(subject.get(url)).to be_a Result::Failure
      end
    end

    context 'when resource not found' do
      before do
        stub_request(:get, "http://www.testing.org:443/404").
         with(  headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Ruby'
           }).
         to_return(status: 404, body: "", headers: {})
      end

      let(:url) { 'https://www.testing.org/404' }

      it 'return returns a failure object' do
        expect(subject.get(url)).to be_a Result::Failure
      end
    end
  end
end
