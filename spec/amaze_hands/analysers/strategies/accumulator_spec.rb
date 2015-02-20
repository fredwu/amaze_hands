RSpec.describe Analysers::Strategies::Accumulator do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'

  subject { CardRepository.find('P-217') }

  context 'no cycle time recorded' do
    its(:cycle_time) { is_expected.to eq(0) }
  end

  context 'with cycle time recorded' do
    before do
      CardLaneRepository.create(CardLane.new(card_number: 'P-217', year: 2015, week: 1, lane: 'Capability: Doing', cycle_time: 3.0))
      CardLaneRepository.create(CardLane.new(card_number: 'P-217', year: 2015, week: 1, lane: 'QA', cycle_time: 1.0))
      described_class.new(type: :cycle_time).apply
    end

    its(:cycle_time) { is_expected.to eq(4.0) }
  end
end
