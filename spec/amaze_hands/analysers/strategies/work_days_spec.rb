RSpec.describe Analysers::Strategies::WorkDays do
  AmazeClass = Class.new do
    prepend Analysers::Strategies::WorkDays

    def formula(card_action, next_card_action)
      (next_card_action.date_time.to_date - card_action.date_time.to_date + 1).to_f
    end
  end

  subject do
    AmazeClass.new.formula(
      CardAction.new(date_time: DateTime.parse(from)),
      CardAction.new(date_time: DateTime.parse(to))
    )
  end

  describe 'with a weekend' do
    let(:from) { '2015-02-26' }
    let(:to)   { '2015-03-02' }

    it { is_expected.to eq(3.0) }
  end

  describe 'with a holiday' do
    let(:from) { '2015-02-17' }
    let(:to)   { '2015-02-20' }

    it { is_expected.to eq(1.0) }
  end
end
