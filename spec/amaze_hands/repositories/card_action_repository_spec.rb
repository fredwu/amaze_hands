RSpec.describe CardActionRepository do
  let(:card)        { FactoryGirl.build(:card) }
  let(:card_action) { FactoryGirl.build(:card_action, card_number: card.number) }

  before do
    CardActionRepository.create(card_action)
    CardActionRepository.create(FactoryGirl.build(:card_action, card_number: card.number, analysable: true))
    CardActionRepository.create(FactoryGirl.build(:card_action, card_number: card.number, analysable: true, description: { ready: true }))
    CardActionRepository.create(FactoryGirl.build(:card_action, card_number: 'P-243'))
    CardActionRepository.create(FactoryGirl.build(:card_action, card_number: 'P-243', analysable: true))
  end

  describe '.all_by_card' do
    subject(:results) { CardActionRepository.all_by_card(card) }

    its(:count) { is_expected.to eq(3) }

    describe 'filtered card' do
      subject { results.first }

      its(:date_time)   { is_expected.to eq(card_action.date_time) }
      its(:description) { is_expected.to eq(card_action.description) }
      its(:card_number) { is_expected.to eq(card.number) }
    end
  end

  describe '.analysable_by_card' do
    subject(:results) { CardActionRepository.analysable_by_card(card) }

    its(:count) { is_expected.to eq(2) }

    describe 'filtered card' do
      subject { results.first }

      its(:analysable) { is_expected.to be(true) }
    end
  end
end
