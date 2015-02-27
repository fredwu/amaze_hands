RSpec.describe Producers::MetricsProducer::MetricProducer do
  let(:metric) { {} }

  let(:producer) do
    described_class.new(:cycle_time,
      metric_key: -> (_) { :amaze },
      items:      [Card.new(cycle_time: 2.0), Card.new(cycle_time: 3.5)],
      year:       2015,
      week:       42
    )
  end

  subject { metric[2015][42][:amaze] }

  before do
    producer.apply_sum!(metric)
    producer.apply_average!(metric)
  end

  its([:sum])     { is_expected.to eq(5.5) }
  its([:average]) { is_expected.to eq(2.8) }
end
