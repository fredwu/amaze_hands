RSpec.describe CardRepository do
  describe 'CRUD' do
    let(:card)     { FactoryGirl.build(:card) }
    let(:bau_card) { FactoryGirl.build(:card, :bau) }

    before do
      CardRepository.create(card)
      CardRepository.create(bau_card)
    end

    describe '.find' do
      context 'card' do
        subject { CardRepository.find('P-217') }

        its(:number) { is_expected.to eq('P-217') }
        its(:type)   { is_expected.to eq(:capability) }
        its(:title)  { is_expected.to eq("Discard 'draft' prices") }
      end

      context 'bau card' do
        subject { CardRepository.find('P-243') }

        its(:number) { is_expected.to eq('P-243') }
        its(:type)   { is_expected.to eq(:bau) }
        its(:title)  { is_expected.to eq('Exception handling in/out of the controllers') }
      end
    end
  end
end
