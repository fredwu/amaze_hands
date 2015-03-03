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
        'Doing: Capability' => { item_values: [6.0, 13.0], sum: 19.0, count: 2, average: 9.5 },
        'QA'                => { item_values: [0.5, 1.5], sum: 2.0, count: 2, average: 1.0 },
        'Deploying'         => { item_values: [0.5], sum: 0.5, count: 1, average: 0.5 },
        'BAT'               => { item_values: [0.5], sum: 0.5, count: 1, average: 0.5 },
        :combined           => { item_values: [6.5, 15.5], sum: 22.0, count: 2, average: 11.0 },
        :combined_rolling   => { item_values: [6.5, 15.5], sum: 22.0, count: 2, average: 11.0 }
      },
      '2015-6' => {
        'Doing: Capability' => { item_values: [2.5], sum: 2.5, count: 1, average: 2.5 },
        'QA'                => { item_values: [1.5], sum: 1.5, count: 1, average: 1.5 },
        'BAT'               => { item_values: [0.5], sum: 0.5, count: 1, average: 0.5 },
        :combined           => { item_values: [4.5], sum: 4.5, count: 1, average: 4.5 },
        :combined_rolling   => { item_values: [6.5, 15.5, 4.5], sum: 26.5, count: 3, average: 8.8 }
      }
    )
  end

  its(:wait_time) do
    is_expected.to eq(
      '2015-4' => {
        'Doing: Capability' => { item_values: [1.0, 0.0], sum: 1.0, count: 2, average: 0.5 },
        'QA'                => { item_values: [0.0, 1.0], sum: 1.0, count: 2, average: 0.5 },
        'Deploying'         => { item_values: [0.0], sum: 0.0, count: 1, average: 0.0 },
        'BAT'               => { item_values: [0.0], sum: 0.0, count: 1, average: 0.0 },
        :combined           => { item_values: [1.0, 1.0], sum: 2.0, count: 2, average: 1.0 },
        :combined_rolling   => { item_values: [1.0, 1.0], sum: 2.0, count: 2, average: 1.0 }
      },
      '2015-6' => {
        'Doing: Capability' => { item_values: [1.0], sum: 1.0, count: 1, average: 1.0 },
        'QA'                => { item_values: [1.0], sum: 1.0, count: 1, average: 1.0 },
        'BAT'               => { item_values: [0.0], sum: 0.0, count: 1, average: 0.0 },
        :combined           => { item_values: [2.0], sum: 2.0, count: 1, average: 2.0 },
        :combined_rolling   => { item_values: [1.0, 1.0, 2.0], sum: 4.0, count: 3, average: 1.3 }
      }
    )
  end
end
