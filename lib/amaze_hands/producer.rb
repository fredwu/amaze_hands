Dir["#{__dir__}/producers/**/*.rb"].each { |f| require f }

class Producer
  attr_reader :card_lanes, :intel

  def initialize
    @card_lanes = CardLaneRepository.all
    @intel      = Intelligence.new
  end

  def metrics
    card_lanes.group_by(&:lane).each do |lane, metrics|
      do_wait_days(lane, metrics)
    end

    intel
  end

  private

  def do_wait_days(lane, metrics)
    intel.wait_days[lane] = metrics.sum(&:wait_days)
  end
end
