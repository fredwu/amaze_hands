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
      '2015-4' => {
        'Doing: Capability' => { sum: 19.0, count: 2, average: 9.5 },
        'QA'                => { sum: 2.0, count: 2, average: 1.0 },
        'Deploying'         => { sum: 0.5, count: 1, average: 0.5 },
        'BAT'               => { sum: 0.5, count: 1, average: 0.5 },
        :combined           => { sum: 22.0, count: 2, average: 11.0 }
      },
      '2015-6' => {
        'Doing: Capability' => { sum: 2.5, count: 1, average: 2.5 },
        'QA'                => { sum: 1.5, count: 1, average: 1.5 },
        'BAT'               => { sum: 0.5, count: 1, average: 0.5 },
        :combined           => { sum: 4.5, count: 1, average: 4.5 }
      }
    )
  end

  its(:wait_time) do
    is_expected.to eq(
      '2015-4' => {
        'Doing: Capability' => { sum: 1.0, count: 2, average: 0.5 },
        'QA'                => { sum: 1.0, count: 2, average: 0.5 },
        'Deploying'         => { sum: 0.0, count: 1, average: 0.0 },
        'BAT'               => { sum: 0.0, count: 1, average: 0.0 },
        :combined           => { sum: 2.0, count: 2, average: 1.0 }
      },
      '2015-6' => {
        'Doing: Capability' => { sum: 1.0, count: 1, average: 1.0 },
        'QA'                => { sum: 1.0, count: 1, average: 1.0 },
        'BAT'               => { sum: 0.0, count: 1, average: 0.0 },
        :combined           => { sum: 2.0, count: 1, average: 2.0 }
      }
    )
  end
end
