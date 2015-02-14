module Strategies
  class Lanes
    def self.with_traits(*traits)
      lanes.select { |lane, lane_traits| (traits - lane_traits).empty? }.keys
    end
  end
end
