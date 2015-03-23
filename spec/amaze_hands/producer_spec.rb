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
        'Doing: Capability' => { item_values: [6.0, 13.0], sum: 19.0, count: 2, mean:  9.5, median:  9.5, standard_deviation: 4.95 },
        'QA'                => { item_values: [0.5, 1.5],  sum:  2.0, count: 2, mean:  1.0, median:  1.0, standard_deviation: 0.71 },
        'Deploying'         => { item_values: [0.5],       sum:  0.5, count: 1, mean:  0.5, median:  0.5, standard_deviation: 0.0 },
        'BAT'               => { item_values: [0.5],       sum:  0.5, count: 1, mean:  0.5, median:  0.5, standard_deviation: 0.0 },
        :combined           => { item_values: [6.5, 15.5], sum: 22.0, count: 2, mean: 11.0, median: 11.0, standard_deviation: 6.36, ucl: 23.43, cl: 8.8, lcl: -5.83 },
        :combined_rolling   => { item_values: [6.5, 15.5], sum: 22.0, count: 2, mean: 11.0, median: 11.0, standard_deviation: 6.36, ucl: 23.43, cl: 8.8, lcl: -5.83 }
      },
      '2015-6' => {
        'Doing: Capability' => { item_values: [2.5],            sum:  2.5, count: 1, mean: 2.5, median: 2.5, standard_deviation: 0.0 },
        'QA'                => { item_values: [1.5],            sum:  1.5, count: 1, mean: 1.5, median: 1.5, standard_deviation: 0.0 },
        'BAT'               => { item_values: [0.5],            sum:  0.5, count: 1, mean: 0.5, median: 0.5, standard_deviation: 0.0 },
        :combined           => { item_values: [4.5],            sum:  4.5, count: 1, mean: 4.5, median: 4.5, standard_deviation: 0.0, ucl: 23.43, cl: 8.8, lcl: -5.83 },
        :combined_rolling   => { item_values: [6.5, 15.5, 4.5], sum: 26.5, count: 3, mean: 8.8, median: 6.5, standard_deviation: 5.86 }
      }
    )
  end

  its(:wait_time) do
    is_expected.to eq(
      '2015-4' => {
        'Doing: Capability' => { item_values: [1.0, 0.0], sum: 1.0, count: 2, mean: 0.5, median: 0.5, standard_deviation: 0.71 },
        'QA'                => { item_values: [0.0, 1.0], sum: 1.0, count: 2, mean: 0.5, median: 0.5, standard_deviation: 0.71 },
        'Deploying'         => { item_values: [0.0],      sum: 0.0, count: 1, mean: 0.0, median: 0.0, standard_deviation: 0.0 },
        'BAT'               => { item_values: [0.0],      sum: 0.0, count: 1, mean: 0.0, median: 0.0, standard_deviation: 0.0 },
        :combined           => { item_values: [1.0, 1.0], sum: 2.0, count: 2, mean: 1.0, median: 1.0, standard_deviation: 0.0 },
        :combined_rolling   => { item_values: [1.0, 1.0], sum: 2.0, count: 2, mean: 1.0, median: 1.0, standard_deviation: 0.0 }
      },
      '2015-6' => {
        'Doing: Capability' => { item_values: [1.0],           sum: 1.0, count: 1, mean: 1.0, median: 1.0, standard_deviation: 0.0 },
        'QA'                => { item_values: [1.0],           sum: 1.0, count: 1, mean: 1.0, median: 1.0, standard_deviation: 0.0 },
        'BAT'               => { item_values: [0.0],           sum: 0.0, count: 1, mean: 0.0, median: 0.0, standard_deviation: 0.0 },
        :combined           => { item_values: [2.0],           sum: 2.0, count: 1, mean: 2.0, median: 2.0, standard_deviation: 0.0 },
        :combined_rolling   => { item_values: [1.0, 1.0, 2.0], sum: 4.0, count: 3, mean: 1.3, median: 1.0, standard_deviation: 0.58 }
      }
    )
  end
end
