RSpec.describe Producer do
  subject do
    Workflow.new(
      strategy: Strategies::LeanKit,
      files:    Dir["#{__dir__}/../fixtures/lean_kit/*.txt"]
    ).metrics
  end

  its(:wait_days) { is_expected.to eq('Doing: Capability' => 0, 'QA' => 0) }
end
