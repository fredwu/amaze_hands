module Producers
  class ControllLimitsProducer
    attr_reader :intel

    def initialize(intel)
      @intel = intel
    end

    def apply
      [:cycle_time].each do |metric_name|
        apply_control_limit!(intel.send(metric_name))
      end
    end

    private

    def apply_control_limit!(metrics)
      return if metrics.empty?

      overall_mean         = calculate_overall_mean(metrics)
      average_moving_range = calculate_average_moving_range(metrics)

      metrics.each do |_, metric_values|
        metric_values[:combined][:ucl] = (
          overall_mean + (2.66 * average_moving_range)
        ).round(2)

        metric_values[:combined][:cl] = (
          overall_mean
        ).round(2)

        metric_values[:combined][:lcl] = (
          overall_mean - (2.66 * average_moving_range)
        ).round(2)
      end
    end

    def calculate_overall_mean(metrics)
      metrics.values.last[:combined_rolling][:mean]
    end

    def calculate_average_moving_range(metrics)
      (
        DescriptiveStatistics::Stats.new(
          metrics.values.last[:combined_rolling][:item_values]
        ).range / (metrics.values.last[:combined_rolling][:count] - 1)
      ).round(2)
    end
  end
end
