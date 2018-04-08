# frozen_string_literal: true

require 'spec_integration'

RSpec.describe 'Locations endpoint' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:locations_double) { double('Protocols::Nsq::Locations', call: '') }

  it "triggers Protocols::Http::ZombieDriver" do
    params = {"longitude"=>"2.3444", "latitude"=>"56.879798", "id"=>"678"}
    expect(Protocols::Nsq::Locations).to receive(:new).with(params).and_return(locations_double)
    patch '/drivers/678/locations', { longitude: 2.3444, latitude: 56.879798 }
  end
end
