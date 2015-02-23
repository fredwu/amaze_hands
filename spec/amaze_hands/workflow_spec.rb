RSpec.describe Workflow do
  subject(:workflow) do
    Workflow.new(
      strategy: Strategies::LeanKit,
      files:    Dir["#{__dir__}/../fixtures/lean_kit/*.txt"]
    )
  end

  its(:metrics) { is_expected.to be_kind_of(Intelligence) }

  describe '#clean_up_db' do
    subject { workflow.send(:clean_up_db) }

    it 'cleans up the DB' do
      expect(CardRepository.all).to be_empty
      expect(CardActionRepository.all).to be_empty
      expect(CardLaneRepository.all).to be_empty
    end
  end
end
