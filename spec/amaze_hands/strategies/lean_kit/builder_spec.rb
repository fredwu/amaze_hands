RSpec.describe Strategies::LeanKit::Builder do
  include_context 'LeanKit P-217'

  shared_examples 'a P-217 model' do
    its(:number) { is_expected.to eq('P-217') }
    its(:type)   { is_expected.to eq(:capability) }
    its(:title)  { is_expected.to eq("Discard 'draft' prices") }
  end

  context 'newly built' do
    subject { card }

    it_behaves_like 'a P-217 model'
  end

  context 'persisted' do
    subject { CardRepository.find(card.number) }

    it_behaves_like 'a P-217 model'
  end
end
