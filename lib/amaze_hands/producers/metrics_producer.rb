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
          produce_items_metric_for(metric_name, items: items_by_week, year: year, week: week)
        end
      end
    end

    def produce_items_metric_for(metric_name, **args)
      metric = intel.send(metric_name)

      producer = MetricProducer.new(metric_name, metric_key: metric_key, **args)
      producer.apply_sum!(metric)
      producer.apply_average!(metric)

      intel.send("#{metric_name}=", metric)
    end

    class MetricProducer
      attr_reader :metric_name, :metric_key, :items, :year, :week

      def initialize(metric_name, metric_key:, items:, year:, week:)
        @metric_name = metric_name
        @metric_key  = metric_key
        @items       = items
        @year        = year
        @week        = week
      end

      def apply_sum!(metric)
        items.each do |item|
          key            = instance_exec(item, &metric_key)
          existing_value = metric.fetch(year, {}).fetch(week, {}).fetch(key, {}).fetch(:sum, 0)
          value          = item.send(metric_name) + existing_value

          metric.deep_merge!(year => { week => { key => { sum: value } } })

          increase_counter!(metric[year][week][key])
        end
      end

      def apply_average!(metric)
        metric.each do |year, metric_by_year|
          metric_by_year.each do |week, metric_by_week|
            metric_by_week.each do |key, calculated_metric|
              calculated_metric[:average] = (calculated_metric[:sum] / calculated_metric[:count]).round(1)
            end
          end
        end
      end

      private

      def increase_counter!(metric_hash)
        metric_hash[:count] = metric_hash.fetch(:count, 0) + 1
      end
    end
  end
end
