RSpec.describe Strategies::LeanKit::Transformers::ServiceLabel do
  subject { described_class.new(input) }

  describe 'empty' do
    let(:input) { nil }

    its(:transformed) { is_expected.to be_empty }
  end

  describe '<no value>' do
    let(:input) { '<no value>' }

    its(:transformed) { is_expected.to be_empty }
  end
end
