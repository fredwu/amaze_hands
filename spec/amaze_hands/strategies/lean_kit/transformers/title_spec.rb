RSpec.describe Strategies::LeanKit::Transformers::Title do
  subject { described_class.new(input) }

  describe 'Capability' do
    let(:input) { '[C] This is a Capability story.' }

    its(:card_type) { is_expected.to eq(:capability) }
    its(:title)     { is_expected.to eq('This is a Capability story.') }
  end

  describe 'BAU' do
    let(:input) { 'This is a BAU story.' }

    its(:card_type) { is_expected.to eq(:bau) }
    its(:title)     { is_expected.to eq('This is a BAU story.') }
  end
end
