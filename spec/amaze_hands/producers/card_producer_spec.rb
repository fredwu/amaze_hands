RSpec.describe Producers::CardProducer do
  let(:measure_every) { 2.weeks }
  let(:start_date)    { DateTime.parse('19-01-2015') }
  let(:producer)      { described_class.new(intel, measure_every: measure_every, start_date: start_date) }

  subject(:intel) { Intelligence.new }

  describe '#apply' do
    before do
      allow(producer).to receive(:collection).and_return(cards)
      producer.apply
    end

    context 'wait times' do
      let(:cards) do
        [
          Card.new(wait_time: 1.0, year: 2015, week: 4),
          Card.new(wait_time: 2.0, year: 2015, week: 5),
          Card.new(wait_time: 3.0, year: 2015, week: 5)
        ]
      end

      its(:wait_time) { is_expected.to eq(2015 => { 4 => { total: 1.0 }, 5 => { total: 5.0 } }) }
    end
  end

  describe '#collection' do
    subject { producer.send(:collection) }

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
      its(:length) { is_expected.to eq(3) }
    end

    context 'without card lanes to produce' do
      let(:start_date) { DateTime.parse('01-06-2015') }

      its(:length) { is_expected.to eq(0) }
    end
  end
end