RSpec.describe Strategies::LeanKit::Transformers::Actions do
  subject(:transformer) { described_class.new(['b', 'a', 4, 2, 'd', 42]) }

  its(:transformed) { is_expected.to eq([42, "d", 2, 4, "a", "b"]) }
end
