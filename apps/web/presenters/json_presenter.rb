module Web::Presenters
  class JSONPresenter
    def initialize(intel)
      @intel = intel
    end

    # rubocop:disable MethodLength
    def metrics(*args)
      m = @intel.metrics(*args)

      {
        types: {
          'Cycle Time'                 => 'bar',
          'Cycle Time Rolling'         => 'spline',
          'Wait Time'                  => 'bar',
          'Wait Time Rolling'          => 'spline',
          'Standard Deviation Rolling' => 'spline'
        },
        xs: {
          'Cycle Time'                 => 'Week',
          'Cycle Time Rolling'         => 'Week',
          'Wait Time'                  => 'Week',
          'Wait Time Rolling'          => 'Week',
          'Standard Deviation Rolling' => 'Week'
        },
        colors: {
          'Cycle Time'                 => '#1F77B4',
          'Cycle Time Rolling'         => '#16547F',
          'Wait Time'                  => '#FF7F0E',
          'Wait Time Rolling'          => '#7F3F07',
          'Standard Deviation Rolling' => '#007F05'
        },
        columns: [
          ['Week'] + m.cycle_time.keys,
          ['Cycle Time'] + m.cycle_time.map { |_, stats| stats[:combined][:mean] },
          ['Cycle Time Rolling'] + m.cycle_time.map { |_, stats| stats[:combined_rolling][:mean] },
          ['Wait Time'] + m.wait_time.map { |_, stats| stats[:combined][:mean] },
          ['Wait Time Rolling'] + m.wait_time.map { |_, stats| stats[:combined_rolling][:mean] },
          ['Standard Deviation Rolling'] + m.wait_time.map { |_, stats| stats[:combined_rolling][:standard_deviation] }
        ]
      }.to_json
    end
    # rubocop:enable MethodLength
  end
end
