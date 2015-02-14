module Strategies
  module LeanKit
    module Transformers
      class Readiness
        attr_reader :transformed

        def initialize(from, to)
          if from == '' && to == 'Expedite'
            @transformed = true
          else
            @transformed = false
          end
        end
      end
    end
  end
end
