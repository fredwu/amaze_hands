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
  end
end
