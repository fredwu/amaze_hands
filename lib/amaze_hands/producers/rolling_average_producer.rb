require_relative 'metrics_producer'

module Producers
  class RollingAverageProducer
    attr_reader :intel

    def initialize(intel)
      @intel = intel
    end

    def apply
      [:cycle_time, :wait_time].each do |metric_name|
        apply_rolling_average!(intel.send(metric_name))
      end
    end

    private

    def apply_rolling_average!(metrics)
      return if metrics.empty?

      set_initial_rolling_data!(metrics)
      calculate_rolling_average!(metrics)
    end

    def set_initial_rolling_data!(metrics)
      metrics.first[1][:combined_rolling] = metrics.first[1][:combined]
    end

    def calculate_rolling_average!(metrics)
      last_value = nil

      metrics.each_with_object(metrics) do |(_, v), updated_metrics|
        unless v.key?(:combined_rolling)
          top_rolling_with_current!(v, last_value)

          MetricsProducer::AverageMaths.new(v[:combined_rolling]).apply!
        end

        last_value = v
      end
    end

    def top_rolling_with_current!(value, last_value)
      value[:combined_rolling] = last_value[:combined_rolling].merge(value[:combined]) do |k, rolling, current|
        rolling + current
      end
    end
  end
end
