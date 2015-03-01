module Producers
  class MetricsProducer
    attr_reader :intel, :frequency, :start_date, :from_year, :from_week

    attr_accessor :repository, :metric_key, :metrics

    def initialize(intel, measure_every:, start_date:)
      @intel      = intel
      @frequency  = measure_every / 1.week
      @start_date = start_date
      @from_year  = start_date.year
      @from_week  = start_date.cweek
    end

    def configure(&block)
      instance_eval(&block)
    end

    def apply
      catalog.each do |year_and_week, items|
        produce_metrics_for(year_and_week, items)
      end
    end

    private

    def catalog
      array_catalog = catalog_pre_frequency.each_slice(frequency).map do |slice|
        key    = slice[0][0]
        values = slice.map { |s| s[1] }.flatten

        [key, values]
      end

      Hash[array_catalog]
    end

    def catalog_pre_frequency
      prefill_catalog_keys(collection).merge(
        collection.group_by { |item| "#{item.year}-#{item.week}" }
      )
    end

    def prefill_catalog_keys(collection)
      return {} if collection.empty?

      last_item = collection.last
      end_date  = Date.commercial(last_item.year, last_item.week, 7)

      keys = (start_date...end_date).map { |date| "#{date.year}-#{date.cweek}" }.uniq

      Hash[keys.product([[]])]
    end

    def collection
      @collection ||= repository.all.select do |item|
        item.year > from_year || (item.year == from_year && item.week >= from_week)
      end
    end

    def produce_metrics_for(year_and_week, items)
      metrics.each do |metric_name|
        produce_metric_for(metric_name, items: items, year_and_week: year_and_week)
      end
    end

    def produce_metric_for(metric_name, **args)
      metric = intel.send(metric_name)

      producer = MetricProducer.new(metric_name, metric_key: metric_key, **args)
      producer.apply_sum!(metric)
      producer.apply_average!(metric)

      intel.send("#{metric_name}=", metric)
    end

    class MetricProducer
      attr_reader :metric_name, :metric_key, :items, :year_and_week

      def initialize(metric_name, metric_key:, items:, year_and_week:)
        @metric_name   = metric_name
        @metric_key    = metric_key
        @items         = items
        @year_and_week = year_and_week
      end

      def apply_sum!(metric)
        items.each do |item|
          key            = instance_exec(item, &metric_key)
          existing_value = metric.fetch(year_and_week, {}).fetch(key, {}).fetch(:sum, 0)
          value          = item.send(metric_name) + existing_value

          metric.deep_merge!(year_and_week => { key => { sum: value } })

          increase_counter!(metric[year_and_week][key])
        end
      end

      def apply_average!(metric)
        metric.each do |year_and_week, metric|
          metric.each do |_, calculated_metric|
            calculated_metric[:average] = (calculated_metric[:sum] / calculated_metric[:count]).round(1)
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