RSpec.describe CardLane do
  describe '#wait_days' do
    subject { CardLane.new }

    context 'when new' do
      its(:wait_days) { is_expected.to eq(0) }
    end

    context 'when calculated' do
      before do
        subject.wait_days += 42
      end

      its(:wait_days) { is_expected.to eq(42) }
    end
  end
end
