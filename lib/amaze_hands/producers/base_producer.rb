module Producers
  class BaseProducer
    attr_reader :intel, :from_year, :from_week

    def initialize(intel, measure_every:, start_date:)
      @intel     = intel
      @from_year = start_date.year
      @from_week = start_date.cweek
    end

    def apply
      collection.each_with_object({}) do |item, catalog|
        catalog_by_year_and_week(catalog, item)
      end.each do |year, items_by_year|
        produce_metrics_for(year, items_by_year)
      end
    end

    private

    def collection
      @collection ||= repository.all.select do |item|
        item.year > from_year || (item.year == from_year && item.week >= from_week)
      end
    end

    def catalog_by_year_and_week(catalog, item)
      catalog[item.year] ||= {}
      catalog[item.year][item.week] ||= []
      catalog[item.year][item.week] << item
    end

    def produce_metrics_for(year, items_by_year)
      items_by_year.each do |week, items_by_week|
        self.class::AVAILABLE_METRICS.each do |metric_name|
          produce_metric(metric_name, items: items_by_week, year: year, week: week)
        end
      end
    end

    def produce_item_metric_for(label, metric_name:, item:, year:, week:)
      metric = intel.send("#{metric_name}")

      existing_metric_value = metric.fetch(year, {}).fetch(week, {}).fetch(label, 0.0)
      metric_value          = existing_metric_value + item.send(metric_name)

      metric.deep_merge!(year => { week => { label => metric_value } })

      intel.send("#{metric_name}=", metric)
    end
  end
end
