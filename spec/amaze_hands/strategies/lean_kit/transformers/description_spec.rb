RSpec.describe Strategies::LeanKit::Transformers::Description do
  subject(:transformer) { described_class.new(input) }

  describe 'normal' do
    let(:input) { { wow: 'amaze_hands' } }

    its(:transformed) { is_expected.to eq({ wow: 'amaze_hands' }) }
  end

  describe 'in an array' do
    let(:input) { [{ wow: 'amaze_hands' }] }

    its(:transformed) { is_expected.to eq({ wow: 'amaze_hands' }) }
  end
end
