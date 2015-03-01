require_relative 'metrics_producer'

module Producers
  class CardLaneProducer
    attr_reader :producer

    def initialize(intel, **args)
      @producer = MetricsProducer.new(intel, **args)
      @producer.configure do |config|
        config.metrics    = [:cycle_time, :wait_time]
        config.repository = CardLaneRepository
        config.metric_key = -> (item) { item.lane }
      end
    end

    def apply
      producer.apply
    end
  end
end
