require_relative 'base'

module Analysers
  class WaitTime < Base
    def analyse
      Strategies::Accumulator.new(
        type: :wait_time
      ).apply
    end
  end
end
