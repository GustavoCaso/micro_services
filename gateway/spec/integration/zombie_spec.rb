# frozen_string_literal: true
require 'spec_integration'

RSpec.describe 'Zombie driver endpoint' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "triggers Protocols::Http::ZombieDriver" do
    expect(Protocols::Http::ZombieDriver).to receive_message_chain(:new, :call).with({ 'id' => '678' })
    get '/drivers/678'
  end
end

