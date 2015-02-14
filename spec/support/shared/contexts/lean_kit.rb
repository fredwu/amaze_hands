RSpec.shared_context 'LeanKit P-217' do
  let(:fixture)         { Fixture.read('lean_kit/P-217.txt') }
  let(:ast)             { Strategies::LeanKit::Parser.new.parse(fixture) }
  let(:transformed_ast) { Strategies::LeanKit::Transformer.new.apply(ast) }
  let(:card)            { Builder.new(transformed_ast).build }
end

RSpec.shared_context 'LeanKit P-217 actions' do
  let(:card_actions) { CardActionRepository.all_by_card(card) }
end

RSpec.shared_context 'LeanKit P-217 analysable actions' do
  let(:card_actions) { CardActionRepository.analysable_by_card(card) }

  before do
    Reducer.new(card, lanes: Strategies::LeanKit::Lanes).tag
  end
end
