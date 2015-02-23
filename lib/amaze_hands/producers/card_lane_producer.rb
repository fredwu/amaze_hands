module Producers
  class CardLaneProducer < BaseProducer
    AVAILABLE_METRICS = [:cycle_time, :wait_time]

    private

    def repository
      CardLaneRepository
    end

    def produce_metric(metric_name, items:, year:, week:)
      items.each do |item|
        produce_item_metric_for(item.lane, metric_name: metric_name, item: item, year: year, week: week)
      end
    end
  end
end
