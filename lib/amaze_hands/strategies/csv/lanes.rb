require_relative '../lanes'

module Strategies
  module CSV
    class Lanes < Strategies::Lanes
      def self.lanes
        {
          'In Analysis'   => [:initial, :non_analysable],
          'In Dev'        => [:initial, :analysable],
          'In QA'         => [:analysable],
          'In BAT'        => [:analysable],
          'In Deployment' => [:analysable],
          'In Archive'    => [:final, :non_analysable]
        }
      end
    end
  end
end
