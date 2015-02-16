RSpec.describe Analysers::CalendarYearWeek do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject(:all) { CardLaneRepository.all }

    before do
      Analysers::WaitDays.new(card_actions).analyse
      Analysers::CalendarYearWeek.new(card_actions).analyse
    end

    its(:count) { is_expected.to eq(1) }

    describe 'first item' do
      subject { all.first }

      its(:year) { is_expected.to eq(2015) }
      its(:week) { is_expected.to eq(7) }
    end
  end

  describe 'private methods' do
    describe '#first_card_action_date_time' do
      subject { service_class.send(:first_card_action_date_time) }

      its(:to_s) { is_expected.to eq('2015-02-09T14:41:28+10:00') }
    end
  end
end
