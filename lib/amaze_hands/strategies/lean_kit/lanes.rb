require_relative '../lanes'

module Strategies
  module LeanKit
    class PricingLanes < Strategies::Lanes
      def self.lanes
        {
          'Triage: Triage'                  => [:initial, :non_analysable],
          'Prioritised Backlog: Capability' => [:initial, :non_analysable],
          'Prioritised Backlog: BAU'        => [:initial, :non_analysable],
          'In Analysis'                     => [:initial, :non_analysable],
          'Doing: Capability'               => [:initial, :analysable],
          'Doing: BAU'                      => [:initial, :analysable],
          'Doing: Non-dev Tasks'            => [:initial, :analysable],
          'QA'                              => [:analysable],
          'BAT'                             => [:analysable],
          'Deploying'                       => [:analysable],
          'Done'                            => [:non_analysable],
          'Archive: Pricing'                => [:final, :non_analysable]
        }
      end
    end

    class CustomersLanes < Strategies::Lanes
      def self.lanes
        {
          'Capability: Analysis' => [:initial, :non_analysable],
          'Capability: Next'     => [:initial, :non_analysable],
          'Capability: Doing'    => [:initial, :analysable],
          'Capability: QA'       => [:analysable],
          'Capability: BAT'      => [:analysable],
          'Capability: Done'     => [:non_analysable]
        }
      end
    end
  end
end
