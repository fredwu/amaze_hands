RSpec.describe Reducer do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'

  subject { card_actions }

  its(:count) { is_expected.to eq(4) }

  describe 'does not create extra records' do
    subject { CardActionRepository.all_by_card(card) }

    its(:count) { is_expected.to eq(55) }
  end
end
