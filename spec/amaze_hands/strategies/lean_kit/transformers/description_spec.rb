RSpec.describe Strategies::LeanKit::Transformers::Description do
  subject(:transformer) { described_class.new(input) }

  describe 'in a hash' do
    let(:input) { { wow: 'amaze_hands' } }

    its(:transformed) { is_expected.to eq(wow: 'amaze_hands') }
  end

  describe 'in an array with all text nodes' do
    let(:input) { [{ text: 'wow' }, { text: 'amaze_hands' }] }

    its(:transformed) { is_expected.to eq(text: ['wow', 'amaze_hands']) }
  end

  describe 'in an array with text and other nodes' do
    let(:input) { [{ text: 'wow' }, { text: 'amaze_hands' }, { wow: 'amaze_hands' }] }

    its(:transformed) { is_expected.to eq(text: ['wow', 'amaze_hands'], wow: 'amaze_hands') }
  end
end
