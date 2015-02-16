RSpec.describe Analysers::CycleTime do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject { CardLaneRepository.all }

    before do
      Analysers::CycleTime.new(card_actions).analyse
    end

    its(:count) { is_expected.to eq(4) }
  end
end
