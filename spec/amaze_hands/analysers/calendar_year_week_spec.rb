RSpec.describe Analysers::CalendarYearWeek::ForCardLane do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject(:all) { CardLaneRepository.all }

    before do
      CardLaneRepository.create(CardLane.new(card_number: 'P-999', year: 1999, week: 19))

      Analysers::WaitTimePerLane.new(card_actions).analyse
      Analysers::CalendarYearWeek::ForCardLane.new(card_actions).analyse
    end

    its(:count) { is_expected.to eq(2) }

    describe 'existing card lane item' do
      subject { all.first }

      its(:year) { is_expected.to eq(1999) }
      its(:week) { is_expected.to eq(19) }
    end

    describe 'created card lane item' do
      subject { all.last }

      its(:year) { is_expected.to eq(2015) }
      its(:week) { is_expected.to eq(7) }
    end
  end

  describe 'private methods' do
    describe '#card_number' do
      subject { service_class.send(:card_number) }

      it { is_expected.to eq('P-217') }
    end

    describe '#date_time' do
      subject { service_class.send(:date_time) }

      its(:to_s) { is_expected.to eq('2015-02-09T14:41:28+10:00') }
    end
  end
end

RSpec.describe Analysers::CalendarYearWeek::ForCard do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject(:all) { CardRepository.all }

    before do
      CardLaneRepository.create(CardLane.new(card_number: 'P-999', year: 1999, week: 19))
      CardRepository.create(Card.new(number: 'P-999'))

      Analysers::WaitTimePerLane.new(card_actions).analyse
      Analysers::CalendarYearWeek::ForCardLane.new(card_actions).analyse
      Analysers::CalendarYearWeek::ForCard.new.analyse
    end

    its(:count) { is_expected.to eq(2) }

    describe 'P-217' do
      subject { all.first }

      its(:year) { is_expected.to eq(2015) }
      its(:week) { is_expected.to eq(7) }
    end

    describe 'P-999' do
      subject { all.last }

      its(:year) { is_expected.to eq(1999) }
      its(:week) { is_expected.to eq(19) }
    end
  end
end
