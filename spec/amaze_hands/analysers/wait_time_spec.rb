RSpec.describe Analysers::WaitTime do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject(:cards) { CardRepository.all }

    before do
      Analysers::WaitTimePerLane.new(card_actions).analyse
      described_class.new(cards).analyse
    end

    its(:count) { is_expected.to eq(1) }

    describe 'P-217' do
      subject { CardRepository.all.first }

      describe 'records wait time' do
        its(:wait_time) { is_expected.to eq(1.0) }
      end

      describe 'does not record cycle time' do
        its(:cycle_time) { is_expected.to eq(0) }
      end
    end
  end
end
