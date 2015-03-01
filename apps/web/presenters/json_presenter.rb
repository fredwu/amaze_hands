module Web::Presenters
  class JSONPresenter
    def initialize(intel)
      @intel = intel
    end

    def metrics(*args)
      original_metrics = @intel.metrics(*args)

      {
        labels: original_metrics.cycle_time.keys,
        series: [
          {
            name: 'Cycle Time',
            data: original_metrics.cycle_time.map { |_, stats| stats[:combined][:average] }
          },
          {
            name: 'Wait Time',
            data: original_metrics.wait_time.map { |_, stats| stats[:combined][:average] }
          }
        ]
      }.to_json
    end
  end
end
