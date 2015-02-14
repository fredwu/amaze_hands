RSpec.describe Builder do
  include_context 'LeanKit P-217'

  shared_examples 'P-217' do
    subject { target_card }

    its(:number) { is_expected.to eq('P-217') }
    its(:type)   { is_expected.to eq(:capability) }
    its(:title)  { is_expected.to eq("Discard 'draft' prices") }

    describe 'actions' do
      subject(:actions) { CardActionRepository.all_by_card(target_card) }

      its(:count) { is_expected.to eq(55) }

      describe 'oldest (first) action' do
        subject(:action) { actions.first }

        its(:card_number) { is_expected.to eq('P-217') }

        describe '#date_time' do
          subject { action.date_time }

          its(:to_s) { is_expected.to eq('2015-01-09T14:52:51+10:00') }
        end

        describe '#description' do
          subject { action.description }

          its([:created_in]) { is_expected.to eq('Prioritised Backlog: Capability') }
        end
      end
    end
  end

  context 'newly built' do
    let(:target_card) { card }

    it_behaves_like 'P-217'
  end

  context 'persisted' do
    let(:target_card) { CardRepository.find(card.number) }

    it_behaves_like 'P-217'
  end
end
