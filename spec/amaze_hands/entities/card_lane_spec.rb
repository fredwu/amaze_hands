RSpec.describe CardLane do
  describe '#cycle_time' do
    subject { CardLane.new }

    context 'when new' do
      its(:cycle_time) { is_expected.to eq(0) }
    end

    context 'when calculated' do
      before do
        subject.cycle_time += 42
      end

      its(:cycle_time) { is_expected.to eq(42) }
    end
  end

  describe '#wait_time' do
    subject { CardLane.new }

    context 'when new' do
      its(:wait_time) { is_expected.to eq(0) }
    end

    context 'when calculated' do
      before do
        subject.wait_time += 42
      end

      its(:wait_time) { is_expected.to eq(42) }
    end
  end
end
