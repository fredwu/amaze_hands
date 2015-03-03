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
          'Cycle Time (Mean)'           => 'bar',
          'Cycle Time (Mean) Rolling'   => 'spline',
          'Cycle Time (Median)'         => 'bar',
          'Cycle Time (Median) Rolling' => 'spline',
          'Wait Time (Mean)'            => 'bar',
          'Wait Time (Mean) Rolling'    => 'spline',
          'Wait Time (Median)'          => 'bar',
          'Wait Time (Median) Rolling'  => 'spline',
          'Standard Deviation Rolling'  => 'spline'
        },
        xs: {
          'Cycle Time (Mean)'           => 'Week',
          'Cycle Time (Mean) Rolling'   => 'Week',
          'Cycle Time (Median)'         => 'Week',
          'Cycle Time (Median) Rolling' => 'Week',
          'Wait Time (Mean)'            => 'Week',
          'Wait Time (Mean) Rolling'    => 'Week',
          'Wait Time (Median)'          => 'Week',
          'Wait Time (Median) Rolling'  => 'Week',
          'Standard Deviation Rolling'  => 'Week'
        },
        colors: {
          'Cycle Time (Mean)'           => '#1F77B4',
          'Cycle Time (Mean) Rolling'   => '#16547F',
          'Cycle Time (Median)'         => '#2CA9FF',
          'Cycle Time (Median) Rolling' => '#1E75B0',
          'Wait Time (Mean)'            => '#FF7F0E',
          'Wait Time (Mean) Rolling'    => '#7F3F07',
          'Wait Time (Median)'          => '#B25A0C',
          'Wait Time (Median) Rolling'  => '#7F4009',
          'Standard Deviation Rolling'  => '#007F05'
        },
        columns: [
          ['Week'] + m.cycle_time.keys,
          ['Cycle Time (Mean)'] + m.cycle_time.map { |_, stats| stats[:combined][:mean] },
          ['Cycle Time (Mean) Rolling'] + m.cycle_time.map { |_, stats| stats[:combined_rolling][:mean] },
          ['Cycle Time (Median)'] + m.cycle_time.map { |_, stats| stats[:combined][:median] },
          ['Cycle Time (Median) Rolling'] + m.cycle_time.map { |_, stats| stats[:combined_rolling][:median] },
          ['Wait Time (Mean)'] + m.wait_time.map { |_, stats| stats[:combined][:mean] },
          ['Wait Time (Mean) Rolling'] + m.wait_time.map { |_, stats| stats[:combined_rolling][:mean] },
          ['Wait Time (Median)'] + m.wait_time.map { |_, stats| stats[:combined][:median] },
          ['Wait Time (Median) Rolling'] + m.wait_time.map { |_, stats| stats[:combined_rolling][:median] },
          ['Standard Deviation Rolling'] + m.wait_time.map { |_, stats| stats[:combined_rolling][:standard_deviation] }
        ]
      }.to_json
    end
    # rubocop:enable MethodLength
  end
end
