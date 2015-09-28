require_relative '../lanes'

module Strategies
  module LeanKit
    class PricingLanes < Strategies::Lanes
      def self.lanes
        {
          'Triage: Triage'                  => [:initial, :non_analysable],
          'Prioritised Backlog: Non Dev'    => [:initial, :non_analysable],
          'Prioritised Backlog: Capability' => [:initial, :non_analysable],
          'Prioritised Backlog: BAU'        => [:initial, :non_analysable],
          'In Analysis'                     => [:initial, :non_analysable],
          'Doing: Capability'               => [:initial, :analysable],
          'Doing: BAU'                      => [:initial, :analysable],
          'Doing: Non-dev Tasks'            => [:initial, :analysable],
          'Review'                          => [:analysable],
          'QA'                              => [:analysable],
          'BAT'                             => [:analysable],
          'Deploying'                       => [:analysable],
          'Done'                            => [:non_analysable],
          'Archive: Pricing'                => [:final, :non_analysable]
        }
      end
    end
  end
end
