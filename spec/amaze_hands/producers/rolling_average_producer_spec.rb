RSpec.describe Producers::RollingAverageProducer do
  let(:measure_every) { 1.week }
  let(:start_date)    { DateTime.parse('19-01-2015') }
  let(:producer)      { described_class.new(intel) }

  subject(:intel) { Intelligence.new }

  describe '#apply' do
    before do
      allow_any_instance_of(Producers::MetricsProducer).to receive(:collection).and_return(cards)
      Producers::CardProducer.new(intel, measure_every: measure_every, start_date: start_date).apply
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

      its(:wait_time) do
        is_expected.to eq(
          '2015-4' => {
            combined:         { sum: 1.0, count: 1, average: 1.0 },
            combined_rolling: { sum: 1.0, count: 1, average: 1.0 }
          },
          '2015-5' => {
            combined:         { sum: 5.0, count: 2, average: 2.5 },
            combined_rolling: { sum: 6.0, count: 3, average: 2.0 }
          }
        )
      end
    end
  end
end
