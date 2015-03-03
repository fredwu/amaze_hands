RSpec.describe Producers::MetricsProducer do
  subject(:producer) do
    described_class.new(
      Intelligence.new,
      measure_every: 2.week,
      start_date:    DateTime.parse('08-01-2015')
    )
  end

  before do
    producer.configure do |config|
      config.metrics    = [:wait_time]
      config.repository = CardRepository
      config.metric_key = -> (_) { :combined }
    end

    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 1))
    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 4))
    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 6))
    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 6))
    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 7))
    CardRepository.create(FactoryGirl.build(:card, year: 2015, week: 8))

    producer.apply
  end

  its(:catalog_pre_frequency) { is_expected.to_not have_key('2015-1') }
  its(:catalog_pre_frequency) { is_expected.to_not have_key('2015-2') }
  its(:catalog_pre_frequency) { is_expected.to_not have_key('2015-3') }
  its(:catalog_pre_frequency) { is_expected.to     have_key('2015-5') }

  its(:catalog) { is_expected.to     have_key('2015-4') }
  its(:catalog) { is_expected.to_not have_key('2015-5') }
  its(:catalog) { is_expected.to     have_key('2015-6') }
  its(:catalog) { is_expected.to_not have_key('2015-7') }
  its(:catalog) { is_expected.to     have_key('2015-8') }

  describe '#intel' do
    subject { producer.intel }

    its(:wait_time) { is_expected.to     have_key('2015-4') }
    its(:wait_time) { is_expected.to_not have_key('2015-5') }
    its(:wait_time) { is_expected.to     have_key('2015-6') }
    its(:wait_time) { is_expected.to_not have_key('2015-7') }
    its(:wait_time) { is_expected.to     have_key('2015-8') }
  end
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
    producer.apply!(metric)
  end

  its([:item_values]) { is_expected.to eq([2.0, 3.5]) }
  its([:sum])         { is_expected.to eq(5.5) }
  its([:mean])        { is_expected.to eq(2.8) }
end

RSpec.describe Producers::MetricsProducer::AverageMaths do
  subject { { item_values: [[2] * 40, [4, 4]].flatten, sum: 88, count: 42 } }

  before do
    described_class.new(subject).apply_mean!
    described_class.new(subject).apply_median!
  end

  its([:mean])   { is_expected.to eq(2.1) }
  its([:median]) { is_expected.to eq(2.0) }
end
