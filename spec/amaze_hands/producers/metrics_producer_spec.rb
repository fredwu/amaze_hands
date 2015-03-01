RSpec.describe Producers::MetricsProducer do
  subject(:producer) do
    described_class.new(
      Intelligence.new,
      measure_every: 1.week,
      start_date:    DateTime.parse('19-01-2015')
    )
  end

  before do
    producer.configure do |config|
      config.metrics    = [:wait_time]
      config.repository = CardRepository
      config.metric_key = -> (_) { :combined }
    end

    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 3))
    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 4))
    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 6))

    producer.apply
  end

  its(:catalog) { is_expected.to_not have_key('2015-3') }
  its(:catalog) { is_expected.to     have_key('2015-5') }
end

RSpec.describe Producers::MetricsProducer::MetricProducer do
  let(:metric) { {} }

  let(:producer) do
    described_class.new(:cycle_time,
      metric_key:    -> (_) { :amaze },
      items:         [Card.new(cycle_time: 2.0), Card.new(cycle_time: 3.5)],
      year_and_week: "2015-42"
    )
  end

  subject { metric['2015-42'][:amaze] }

  before do
    producer.apply_sum!(metric)
    producer.apply_average!(metric)
  end

  its([:sum])     { is_expected.to eq(5.5) }
  its([:average]) { is_expected.to eq(2.8) }
end
