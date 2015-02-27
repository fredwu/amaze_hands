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

  its(:cycle_time) do
    is_expected.to eq(
      2015 => {
        5 => {
          'Doing: Capability' => { total: 19.0 },
          'QA'                => { total: 1.5 },
          'Deploying'         => { total: 0.5 },
          'BAT'               => { total: 0.5 }
        },
        4 => {
          'Doing: Capability' => { total: 8.0 },
          'QA'                => { total: 0.5 }
        },
        6 => {
          'Doing: Capability' => { total: 4.5 },
          'QA'                => { total: 1.5 },
          'BAT'               => { total: 0.5 }
        }
      }
    )
  end

  its(:wait_time) do
    is_expected.to eq(
      2015 => {
        5 => {
          'Doing: Capability' => { total: 0.0 },
          'QA'                => { total: 1.0 },
          'Deploying'         => { total: 0.0 },
          'BAT'               => { total: 0.0 },
          :combined           => { total: 1.0 }
        },
        4 => {
          'Doing: Capability' => { total: 1.0 },
          'QA'                => { total: 0.0 },
          :combined           => { total: 1.0 }
        },
        6 => {
          'Doing: Capability' => { total: 3.0 },
          'QA'                => { total: 1.0 },
          'BAT'               => { total: 0.0 },
          :combined           => { total: 4.0 }
        }
      }
    )
  end
end
