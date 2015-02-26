require_relative 'metrics_producer'

module Producers
  class CardLaneProducer
    attr_reader :producer

    def initialize(intel, **args)
      @producer = MetricsProducer.new(intel, **args)
      @producer.configure do |producer|
        producer.metrics    = [:cycle_time, :wait_time]
        producer.repository = CardLaneRepository
        producer.metric_key = -> (item) { item.lane }
      end
    end

    def apply
      producer.apply
    end
  end
end
