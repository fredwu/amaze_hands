RSpec.shared_context 'LeanKit P-217' do
  let(:fixture)         { Fixture.read('lean_kit/P-217.txt') }
  let(:ast)             { Strategies::LeanKit::Parser.new.parse(fixture) }
  let(:transformed_ast) { Strategies::LeanKit::Transformer.new.apply(ast) }
  let(:card)            { Strategies::LeanKit::Builder.new(transformed_ast).build }
end

RSpec.shared_context 'LeanKit P-217 actions' do
  let(:card_actions) { CardActionRepository.all_by_card(card) }
end

RSpec.shared_context 'LeanKit card actions reducer' do
  let(:reducer) { described_class.new(card_actions) }

  subject { CardActionRepository.analysable_by_card(card) }
end
