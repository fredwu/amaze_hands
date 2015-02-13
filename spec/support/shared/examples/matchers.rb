RSpec.shared_examples 'a match' do
  it { is_expected.to be(true) }
end

RSpec.shared_examples 'a non-match' do
  it { is_expected.to be(false) }
end
