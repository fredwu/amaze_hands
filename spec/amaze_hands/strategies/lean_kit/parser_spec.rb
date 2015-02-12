RSpec.describe Strategies::LeanKit::Parser do
  include_context 'LeanKit P-217'

  its([:card_number]) { is_expected.to eq('P-217') }
  its([:title])       { is_expected.to eq("[C] Discard 'draft' prices") }

  describe 'actions' do
    shared_context 'action' do |time_string|
      let(:action_ast) { actions_ast.detect { |node| node[:timestamp][:time] == time_string } }

      subject { action_ast[:description][0] }
    end

    subject(:actions_ast) { ast[:actions] }

    its(:length) { is_expected.to eq(55) }

    describe '02/10/2015 at 01:34:57 PM - Fred Wu moved this Card from BAT to Done' do
      include_context 'action', '01:34:57 PM'

      its([:from]) { is_expected.to eq('BAT') }
      its([:to])   { is_expected.to eq('Done') }
    end

    describe '02/10/2015 at 01:34:39 PM - Fred Wu changed this Card: Class of Service: from "Expedite" to ""' do
      include_context 'action', '01:34:39 PM'

      its([:service_from]) { is_expected.to eq('Expedite') }
      its([:service_to])   { is_expected.to be_nil }
    end

    describe '02/09/2015 at 06:32:25 PM - Xi Chen changed this Card: Class of Service: from <no value> to "Expedite"' do
      include_context 'action', '06:32:25 PM'

      its([:service_from]) { is_expected.to eq('<no value>') }
      its([:service_to])   { is_expected.to eq('Expedite') }
    end

    describe '01/27/2015 at 05:44:02 PM - Wen Luo moved this Card from Prioritised Backlog: Capability to In Analysis' do
      include_context 'action', '05:44:02 PM'

      its([:from]) { is_expected.to eq('Prioritised Backlog: Capability') }
      its([:to])   { is_expected.to eq('In Analysis') }
    end

    describe '01/09/2015 at 02:52:51 PM - Fred Wu created this Card within the Prioritised Backlog: Capability Lane.' do
      include_context 'action', '02:52:51 PM'

      its([:created_in]) { is_expected.to eq('Prioritised Backlog: Capability') }
    end

    describe '02/02/2015 at 12:53:46 PM - Yaowei Du set the status of this Card to Blocked' do
      include_context 'action', '12:53:46 PM'

      its([:blocked_status]) { is_expected.to eq('Blocked') }
    end

    describe '02/03/2015 at 01:41:39 PM - Wen Luo set the status of this Card to Unblocked' do
      include_context 'action', '01:41:39 PM'

      its([:blocked_status]) { is_expected.to eq('Unblocked') }
    end
  end
end
