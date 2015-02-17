RSpec.describe Analysers::WaitTimePerLane do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject { CardLaneRepository.all }

    before do
      Analysers::WaitTimePerLane.new(card_actions).analyse
    end

    its(:count) { is_expected.to eq(1) }
  end
end
