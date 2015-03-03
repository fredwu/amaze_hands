module Producers
  class StandardDeviationProducer
    attr_reader :intel

    def initialize(intel)
      @intel = intel
    end

    def apply
      [:cycle_time, :wait_time].each do |metric_name|
        apply_standard_deviation!(intel.send(metric_name))
      end
    end

    private

    def apply_standard_deviation!(metrics)
      return if metrics.empty?

      metrics.each do |_, metric_values|
        metric_values.each do |_, metric_value|
          metric_value[:standard_deviation] = (
            DescriptiveStatistics::Stats.new(metric_value[:item_values]).standard_deviation || 0
          ).round(1)
        end
      end
    end
  end
end
