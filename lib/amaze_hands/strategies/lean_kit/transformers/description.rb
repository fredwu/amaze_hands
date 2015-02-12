module Strategies
  module LeanKit
    module Transformers
      class Description
        attr_reader :transformed

        def initialize(input)
          @transformed = if input.is_a?(Array)
            input.first
          else
            input
          end
        end
      end
    end
  end
end
