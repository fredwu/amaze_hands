RSpec.describe Strategies::LeanKit::Transformers::Readiness do
  subject { described_class.new(from, to) }

  describe 'ready' do
    let(:from) { '' }
    let(:to)   { 'Expedite' }

    its(:transformed) { is_expected.to be(true) }
  end

  describe 'non-ready' do
    let(:from) { 'Expedite' }
    let(:to)   { '' }

    its(:transformed) { is_expected.to be(false) }
  end
end
