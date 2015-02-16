Dir["#{__dir__}/producers/**/*.rb"].each { |f| require f }

class Producer
  attr_reader :intel, :from_year, :from_week

  def initialize(measure_every:, start_date:)
    @intel     = Intelligence.new
    @from_year = start_date.year
    @from_week = start_date.cweek
  end

  def metrics
    card_lanes_to_produce.each_with_object({}) do |card_lane, card_lanes_by_year_week|
      card_lanes_by_year_week[card_lane.year] ||= {}
      card_lanes_by_year_week[card_lane.year][card_lane.week] ||= []
      card_lanes_by_year_week[card_lane.year][card_lane.week] << card_lane
    end.each do |year, card_lanes_by_week|
      card_lanes_by_week.each do |week, card_lanes_of_the_week|
        do_wait_days(card_lanes_of_the_week)
      end
    end

    intel
  end

  private

  def card_lanes_to_produce
    @card_lanes_to_produce ||= CardLaneRepository.all.select do |card_lane|
      (card_lane.year >= from_year) && (card_lane.week >= from_week)
    end
  end

  def do_wait_days(card_lanes)
    card_lane = card_lanes.first

    year = card_lane.year
    week = card_lane.week
    lane = card_lane.lane

    intel.wait_days[year] ||= {}
    intel.wait_days[year][week] ||= {}
    intel.wait_days[year][week][lane] = card_lanes.sum(&:wait_days)
  end
end
