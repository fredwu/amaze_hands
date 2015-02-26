module Producers
  class CardProducer < BaseProducer
    AVAILABLE_METRICS = [:wait_time]

    private

    def repository
      CardRepository
    end

    def metric_key(_)
      :combined
    end
  end
end
