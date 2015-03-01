module Web::Presenters
  class JSONPresenter
    def initialize(intel)
      @intel = intel
    end

    def metrics(*args)
      _metrics = @intel.metrics(*args)

      {
        labels: _metrics.cycle_time.keys,
        series: [
          {
            name: 'Cycle Time',
            data: _metrics.cycle_time.map { |_, stats| stats[:combined][:average] }
          },
          {
            name: 'Wait Time',
            data: _metrics.wait_time.map { |_, stats| stats[:combined][:average] }
          }
        ]
      }.to_json
    end
  end
end
