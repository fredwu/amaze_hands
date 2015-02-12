RSpec.describe Strategies::LeanKit::Builder do
  include_context 'LeanKit P-217'

  subject { card }

  its(:number) { is_expected.to eq('P-217') }
  its(:type)   { is_expected.to eq(:capability) }
  its(:title)  { is_expected.to eq("Discard 'draft' prices") }
end
