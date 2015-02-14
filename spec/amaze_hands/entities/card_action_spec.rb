RSpec.describe CardAction do
  describe '#lane_movement?' do
    describe 'true' do
      subject { FactoryGirl.build(:card_action, :movement) }

      its(:lane_movement?) { is_expected.to be(true) }
    end

    describe 'false' do
      subject { FactoryGirl.build(:card_action) }

      its(:lane_movement?) { is_expected.to be(false) }
    end
  end
end
