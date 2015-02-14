RSpec.shared_context 'Card actions service class' do
  let(:service_class) { described_class.new(card_actions) }

  subject(:result) { service_class.send(method_name, card_action) }
end
