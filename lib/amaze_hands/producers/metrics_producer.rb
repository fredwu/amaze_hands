module Producers
  class MetricsProducer
    attr_reader :intel, :from_year, :from_week
    attr_accessor :repository, :metric_key, :metrics

    def initialize(intel, measure_every:, start_date:)
      @intel      = intel
      @from_year  = start_date.year
      @from_week  = start_date.cweek
    end

    def configure(&block)
      instance_eval(&block)
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
        metrics.each do |metric_name|
          items_by_week.each do |item|
            produce_item_metric_for(metric_name, item: item, year: year, week: week)
          end
        end
      end
    end

    def produce_item_metric_for(metric_name, item:, year:, week:)
      metric = intel.send("#{metric_name}")

      key = instance_exec(item, &metric_key)

      existing_metric_value = metric.fetch(year, {}).fetch(week, {}).fetch(key, {}).fetch(:sum, 0)
      metric_value          = existing_metric_value + item.send(metric_name)

      metric.deep_merge!(year => { week => { key => { sum: metric_value } } })

      intel.send("#{metric_name}=", metric)
    end
  end
end
