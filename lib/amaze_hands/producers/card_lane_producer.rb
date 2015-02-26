module Producers
  class CardLaneProducer < BaseProducer
    AVAILABLE_METRICS = [:cycle_time, :wait_time]

    private

    def repository
      CardLaneRepository
    end

    def metric_key(item)
      item.lane
    end
  end
end
