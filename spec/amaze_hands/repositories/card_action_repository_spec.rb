RSpec.describe CardActionRepository do
  let(:card)        { FactoryGirl.build(:card) }
  let(:card_action) { FactoryGirl.build(:card_action, card_number: card.number) }

  before do
    CardActionRepository.create(card_action)
    CardActionRepository.create(FactoryGirl.build(:card_action, card_number: 'P-243'))
  end

  describe '.filter_by_card' do
    subject(:results) { CardActionRepository.filter_by_card(card) }

    its(:count) { is_expected.to eq(1) }

    describe 'filtered card' do
      subject { results.first }

      its(:date_time)   { is_expected.to eq(card_action.date_time) }
      its(:description) { is_expected.to eq(card_action.description) }
      its(:card_number) { is_expected.to eq(card.number) }
    end
  end
end
