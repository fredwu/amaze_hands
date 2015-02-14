RSpec.describe Strategies::LeanKit::Transformer do
  include_context 'LeanKit P-217'

  subject { transformed_ast }

  its([:card_number]) { is_expected.to eq('P-217') }
  its([:card_type])   { is_expected.to eq(:capability) }
  its([:title])       { is_expected.to eq("Discard 'draft' prices") }

  describe 'actions' do
    subject(:actions_ast) { transformed_ast[:actions] }

    its(:length) { is_expected.to eq(55) }

    describe 'oldest (first) action' do
      subject(:action_ast) { actions_ast.first }

      describe 'date time' do
        subject { action_ast[:date_time] }

        its(:to_s) { is_expected.to eq('2015-01-09T14:52:51+10:00') }
      end

      describe 'description' do
        subject { action_ast[:description] }

        its([:created_in]) { is_expected.to eq('Prioritised Backlog: Capability') }
      end
    end

    describe 'newest (last) action' do
      subject(:action_ast) { actions_ast.last }

      describe 'date time' do
        subject { action_ast[:date_time] }

        its(:to_s) { is_expected.to eq('2015-02-10T13:34:57+10:00') }
      end

      describe 'description' do
        subject { action_ast[:description] }

        its([:from]) { is_expected.to eq('BAT') }
        its([:to])   { is_expected.to eq('Done') }
      end
    end

    describe 'other actions' do
      shared_context 'action' do |time_string|
        let(:action_ast) { actions_ast.detect { |node| node[:time] == time_string } }

        subject { action_ast[:description] }
      end

      describe 'Class of Service: from "Expedite" to <no value>' do
        include_context 'action', '02:43:28 PM'

        its([:ready]) { is_expected.to be(false) }
      end

      describe 'Class of Service: from <no value> to "Expedite"' do
        include_context 'action', '06:32:25 PM'

        its([:ready]) { is_expected.to be(true) }
      end

      describe 'Class of Service: from "Expedite" to ""' do
        include_context 'action', '01:34:39 PM'

        its([:ready]) { is_expected.to be(false) }
      end
    end
  end
end
