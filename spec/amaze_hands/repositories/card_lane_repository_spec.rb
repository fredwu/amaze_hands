RSpec.describe CardLaneRepository do
  describe '.find_or_create' do
    shared_examples 'card lane entity' do
      its(:id)          { is_expected.to_not be_nil }
      its(:card_number) { is_expected.to eq('P-217') }
      its(:lane)        { is_expected.to eq('QA') }

      context 'card lane collection' do
        subject { CardLaneRepository.all }

        before do
          find_or_create_card_lane_entity
        end

        its(:count) { is_expected.to eq(1) }
      end
    end

    let(:conditions) { { card_number: 'P-217', lane: 'QA' } }

    subject(:find_or_create_card_lane_entity) { CardLaneRepository.find_or_create(conditions) }

    context 'non-existing entity' do
      it_behaves_like 'card lane entity'
    end

    context 'existing entity' do
      let(:card_lane) { FactoryGirl.build(:card_lane, conditions) }

      before do
        CardLaneRepository.create(card_lane)
      end

      it_behaves_like 'card lane entity'
    end
  end
end
