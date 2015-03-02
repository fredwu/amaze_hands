module Web::Presenters
  class JSONPresenter
    def initialize(intel)
      @intel = intel
    end

    def metrics(*args)
      original_metrics = @intel.metrics(*args)

      {
        types: {
          'Cycle Time'         => 'bar',
          'Cycle Time Rolling' => 'spline',
          'Wait Time'          => 'bar',
          'Wait Time Rolling'  => 'spline'
        },
        xs: {
          'Cycle Time'         => 'Week',
          'Cycle Time Rolling' => 'Week',
          'Wait Time'          => 'Week',
          'Wait Time Rolling'  => 'Week'
        },
        colors: {
          'Cycle Time'         => '#1F77B4',
          'Cycle Time Rolling' => '#16547F',
          'Wait Time'          => '#FF7F0E',
          'Wait Time Rolling'  => '#7F3F07'
        },
        columns: [
          ['Week'] + original_metrics.cycle_time.keys,
          ['Cycle Time'] + original_metrics.cycle_time.map { |_, stats| stats[:combined][:average] },
          ['Cycle Time Rolling'] + original_metrics.cycle_time.map { |_, stats| stats[:combined_rolling][:average] },
          ['Wait Time'] + original_metrics.wait_time.map { |_, stats| stats[:combined][:average] },
          ['Wait Time Rolling'] + original_metrics.wait_time.map { |_, stats| stats[:combined_rolling][:average] }
        ]
      }.to_json
    end
  end
end
