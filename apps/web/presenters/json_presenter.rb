module Web::Presenters
  class JSONPresenter
    def initialize(intel)
      @intel = intel
    end

    def metrics(*args)
      original_metrics = @intel.metrics(*args)

      {
        type: 'bar',
        xs: {
          'Cycle Time' => 'Week',
          'Wait Time'  => 'Week'
        },
        columns: [
          ['Week'] + original_metrics.cycle_time.keys,
          ['Cycle Time'] + original_metrics.cycle_time.map { |_, stats| stats[:combined][:average] },
          ['Wait Time'] + original_metrics.wait_time.map { |_, stats| stats[:combined][:average] }
        ]
      }.to_json
    end
  end
end
