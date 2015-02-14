module Strategies
  module LeanKit
    class Lanes
      LANES = {
        'Triage: Triage'                  => [:initial, :non_analysable],
        'Prioritised Backlog: Capability' => [:initial, :non_analysable],
        'Prioritised Backlog: BAU'        => [:initial, :non_analysable],
        'In Analysis'                     => [:initial, :non_analysable],
        'Doing: Capability'               => [:initial, :analysable],
        'Doing: BAU'                      => [:initial, :analysable],
        'QA'                              => [:analysable],
        'BAT'                             => [:analysable],
        'Deploying'                       => [:non_analysable],
        'Done'                            => [:final, :analysable],
        'Archive: Pricing'                => [:final, :non_analysable]
      }

      def self.with_traits(*traits)
        LANES.select { |lane, lane_traits| (traits - lane_traits).empty? }.keys
      end
    end
  end
end
