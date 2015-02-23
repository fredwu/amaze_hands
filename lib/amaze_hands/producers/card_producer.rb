module Producers
  class CardProducer < BaseProducer
    AVAILABLE_METRICS = [:wait_time]

    private

    def repository
      CardRepository
    end

    def produce_metric(metric_name, items:, year:, week:)
      items.each do |item|
        metric = intel.send("#{metric_name}")

        existing_metric_value = metric.fetch(year, {}).fetch(week, {}).fetch(:total, 0.0)
        metric_value          = existing_metric_value + item.send(metric_name)

        metric.deep_merge!(year => { week => { total: metric_value } })

        intel.send("#{metric_name}=", metric)
      end
    end
  end
end
