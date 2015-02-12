RSpec.shared_context 'LeanKit P-217' do
  let(:fixture) { Fixture.read('lean_kit/P-217.txt') }
  subject(:ast) { Strategies::LeanKit::Parser.new.parse(fixture) }
end
