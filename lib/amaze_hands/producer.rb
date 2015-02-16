Dir["#{__dir__}/producers/**/*.rb"].each { |f| require f }

class Producer
  AVAILABLE_METRICS = [:cycle_time, :wait_time]

  attr_reader :intel, :from_year, :from_week

  def initialize(measure_every:, start_date:)
    @intel     = Intelligence.new
    @from_year = start_date.year
    @from_week = start_date.cweek
  end

  def metrics
    card_lanes_to_produce.each_with_object({}) do |card_lane, catalog|
      catalog_card_lanes_by_year_and_week(catalog, card_lane)
    end.each do |year, card_lanes_by_year|
      produce_metrics_for(year, card_lanes_by_year)
    end

    intel
  end

  private

  def card_lanes_to_produce
    @card_lanes_to_produce ||= CardLaneRepository.all.select do |card_lane|
      card_lane.year > from_year || (card_lane.year == from_year && card_lane.week >= from_week)
    end
  end

  def catalog_card_lanes_by_year_and_week(catalog, card_lane)
    catalog[card_lane.year] ||= {}
    catalog[card_lane.year][card_lane.week] ||= []
    catalog[card_lane.year][card_lane.week] << card_lane
  end

  def produce_metrics_for(year, card_lanes_by_year)
    card_lanes_by_year.each do |week, card_lanes_by_week|
      AVAILABLE_METRICS.each do |metric_name|
        produce_metric(metric_name, card_lanes: card_lanes_by_week, year: year, week: week)
      end
    end
  end

  def produce_metric(metric_name, card_lanes:, year:, week:)
    card_lanes.each do |card_lane|
      metric = intel.send("#{metric_name}")
      metric.deep_merge!(year => { week => { card_lane.lane => card_lane.send(metric_name) } })
      intel.send("#{metric_name}=", metric)
    end
  end
end
