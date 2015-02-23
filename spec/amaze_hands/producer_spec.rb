RSpec.describe Producer do
  let(:measure_every) { 2.weeks }
  let(:start_date)    { DateTime.parse('19-01-2015') }

  subject(:workflow) do
    Workflow.new(
      strategy: Strategies::LeanKit,
      files:    Dir["#{__dir__}/../fixtures/lean_kit/*.txt"]
    ).metrics(
      measure_every: measure_every,
      start_date:    start_date
    )
  end

  its(:cycle_time) { is_expected.to eq(2015 => { 7 => { 'Doing: Capability' => 3.0, 'QA' => 1.0, 'Deploying' => 0.5, 'BAT' => 0 }, 5 => { 'Doing: Capability' => 0.5, 'QA' => 0 } }) }
  its(:wait_time)  { is_expected.to eq(2015 => { 7 => { 'Doing: Capability' => 0, 'QA' => 2.0, 'Deploying' => 0, 'BAT' => 0, total: 2.0 }, 5 => { 'Doing: Capability' => 0, 'QA' => 0, total: 0 } }) }
end
