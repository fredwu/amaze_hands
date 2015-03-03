RSpec.describe Producers::CardLaneProducer do
  let(:measure_every) { 1.week }
  let(:start_date)    { DateTime.parse('19-01-2015') }
  let(:producer)      { described_class.new(intel, measure_every: measure_every, start_date: start_date) }

  subject(:intel) { Intelligence.new }

  describe '#apply' do
    before do
      allow_any_instance_of(Producers::MetricsProducer).to receive(:collection).and_return(card_lanes)
      producer.apply
    end

    context 'wait times' do
      let(:card_lanes) do
        [
          CardLane.new(wait_time: 1.0, year: 2015, week: 4, lane: 'Doing: Capability'),
          CardLane.new(wait_time: 2.0, year: 2015, week: 5, lane: 'QA'),
          CardLane.new(wait_time: 3.0, year: 2015, week: 5, lane: 'BAT')
        ]
      end

      its(:wait_time) do
        is_expected.to eq(
          '2015-4' => {
            'Doing: Capability' => { item_values: [1.0], sum: 1.0, count: 1, mean: 1.0 }
          },
          '2015-5' => {
            'QA'  => { item_values: [2.0], sum: 2.0, count: 1, mean: 2.0 },
            'BAT' => { item_values: [3.0], sum: 3.0, count: 1, mean: 3.0 }
          }
        )
      end
    end
  end

  describe '#collection' do
    subject { producer.send(:producer).send(:collection) }

    before do
      Workflow.new(
        strategy: Strategies::LeanKit,
        files:    Dir["#{__dir__}/../../fixtures/lean_kit/*.txt"]
      ).metrics(
        measure_every: measure_every,
        start_date:    start_date
      )
    end

    context 'with card lanes to produce' do
      its(:length) { is_expected.to eq(9) }
    end

    context 'without card lanes to produce' do
      let(:start_date) { DateTime.parse('01-06-2015') }

      its(:length) { is_expected.to eq(0) }
    end
  end
end
