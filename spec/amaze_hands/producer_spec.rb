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

  its(:wait_days) { is_expected.to eq(2015 => { 5 => { 'QA' => 0 } }) }

  describe 'private methods' do
    let(:producer) { Producer.new(measure_every: measure_every, start_date: start_date) }

    before do
      workflow
    end

    describe '#card_lanes_to_produce' do
      subject { producer.send(:card_lanes_to_produce) }

      context 'with card lanes to produce' do
        its(:length) { is_expected.to eq(1) }
      end

      context 'without card lanes to produce' do
        let(:start_date) { DateTime.parse('01-03-2015') }

        its(:length) { is_expected.to eq(0) }
      end
    end

    describe '#do_wait_days' do
      let(:card_lanes) do
        [
          CardLane.new(wait_days: 1, year: 2015, week: 4, lane: 'Doing: Capability'),
          CardLane.new(wait_days: 2, year: 2015, week: 5, lane: 'QA')
        ]
      end

      subject { producer.send(:do_wait_days, card_lanes) }

      it { is_expected.to eq(3) }
    end
  end
end
