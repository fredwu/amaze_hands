require_relative 'metrics_producer'

module Producers
  class CardProducer
    attr_reader :producer

    def initialize(intel, **args)
      @producer = MetricsProducer.new(intel, **args)
      @producer.configure do |producer|
        producer.metrics    = [:wait_time]
        producer.repository = CardRepository
        producer.metric_key = -> (_) { :combined }
      end
    end

    def apply
      producer.apply
    end
  end
end
