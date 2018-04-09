# frozen_string_literal: true

require_relative '../../../lib/services/loop'
require_relative '../../../lib/services/redis'

RSpec.describe Services::Loop do
  subject { described_class }

  before do
    # simple yield to the block without any looping
    allow(subject).to receive(:loop).and_yield
  end

  it 'calls start a Listener' do
    expect(Services::Listener).to receive_message_chain(:new, :call)
    subject.call
  end
end
