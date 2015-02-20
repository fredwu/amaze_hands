RSpec.describe Producer do
  let(:measure_every) { 2.weeks }
  let(:start_date)    { DateTime.parse('19-01-2015') }

  subject(:workflow) do
    Workflow.new(
      strategy: Strategies::LeanKit,
      files:    Dir["#{__dir__}/../fixtures/lean_kit/*.txt"]
    ).metrics(
      measure_every: measure_every,
      start_date:    start_date
    )
  end

  its(:cycle_time) { is_expected.to eq(2015 => { 7 => { 'Doing: Capability' => 3.0, 'QA' => 1.0, 'Deploying' => 0.5, 'BAT' => 0.0 }, 5 => { 'Doing: Capability' => 0.5, 'QA' => 0.0 } }) }
  its(:wait_time)  { is_expected.to eq(2015 => { 7 => { 'Doing: Capability' => 0.0, 'QA' => 2.0, 'Deploying' => 0.0, 'BAT' => 0.0 }, 5 => { 'Doing: Capability' => 0.0, 'QA' => 0.0 } }) }

  describe 'methods' do
    let(:producer) { Producer.new(measure_every: measure_every, start_date: start_date) }

    before do
      workflow
    end

    describe '#metrics' do
      subject { producer.send(:metrics) }

      before do
        allow(producer).to receive(:card_lanes_to_produce).and_return(card_lanes)
      end

      context 'cycle times' do
        let(:card_lanes) do
          [
            CardLane.new(cycle_time: 1.0, year: 2015, week: 4, lane: 'Doing: Capability'),
            CardLane.new(cycle_time: 2.0, year: 2015, week: 5, lane: 'QA'),
            CardLane.new(cycle_time: 3.0, year: 2015, week: 5, lane: 'BAT')
          ]
        end

        its(:cycle_time) { is_expected.to eq(2015 => { 4 => { 'Doing: Capability' => 1.0 }, 5 => { 'QA' => 2.0, 'BAT' => 3.0 } }) }
      end

      context 'wait times' do
        let(:card_lanes) do
          [
            CardLane.new(wait_time: 1.0, year: 2015, week: 4, lane: 'Doing: Capability'),
            CardLane.new(wait_time: 2.0, year: 2015, week: 5, lane: 'QA'),
            CardLane.new(wait_time: 3.0, year: 2015, week: 5, lane: 'BAT')
          ]
        end

        its(:wait_time) { is_expected.to eq(2015 => { 4 => { 'Doing: Capability' => 1.0 }, 5 => { 'QA' => 2.0, 'BAT' => 3.0 } }) }
      end
    end

    describe '#card_lanes_to_produce' do
      subject { producer.send(:card_lanes_to_produce) }

      context 'with card lanes to produce' do
        its(:length) { is_expected.to eq(9) }
      end

      context 'without card lanes to produce' do
        let(:start_date) { DateTime.parse('01-06-2015') }

        its(:length) { is_expected.to eq(0) }
      end
    end
  end
end
