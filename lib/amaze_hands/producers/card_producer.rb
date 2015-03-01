require_relative 'metrics_producer'

module Producers
  class CardProducer
    attr_reader :producer

    def initialize(intel, **args)
      @producer = MetricsProducer.new(intel, **args)
      @producer.configure do |config|
        config.metrics    = [:cycle_time, :wait_time]
        config.repository = CardRepository
        config.metric_key = -> (_) { :combined }
      end
    end

    def apply
      producer.apply
    end
  end
end
