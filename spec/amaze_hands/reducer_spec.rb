RSpec.describe Reducer do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 actions'

  subject { CardActionRepository.analysable_by_card(card) }

  before do
    described_class.new(card, lanes: Strategies::LeanKit::Lanes).tag
  end

  describe 'does not create extra records' do
    subject { card_actions }

    its(:count) { is_expected.to eq(55) }
  end

  its(:count) { is_expected.to eq(7) }
end
