RSpec.describe Strategies::LeanKit::Transformers::DateTime do
  subject(:transformer) { described_class.new('04/02/2042', '11:12:13 PM') }

  describe 'date time string' do
    subject { transformer.transformed }

    its(:to_s) { is_expected.to eq('2042-04-02T23:12:13+10:00') }
  end
end
