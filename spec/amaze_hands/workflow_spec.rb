RSpec.describe Workflow do
  subject do
    Workflow.new(
      strategy: Strategies::LeanKit,
      files:    Dir["#{__dir__}/../fixtures/lean_kit/*.txt"]
    )
  end

  its(:metrics) { is_expected.to be_kind_of(Intelligence) }
end
