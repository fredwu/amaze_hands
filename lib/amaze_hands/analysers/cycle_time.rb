require_relative 'base'

module Analysers
  class CycleTime < Base
    def analyse
      Strategies::Accumulator.new(
        type: :cycle_time
      ).apply
    end
  end
end
