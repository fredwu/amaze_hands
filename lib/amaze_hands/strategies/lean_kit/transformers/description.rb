module Strategies
  module LeanKit
    module Transformers
      class Description
        attr_reader :transformed

        def initialize(input)
          if input.is_a?(Array)
            @transformed = input.first
          else
            @transformed = input
          end
        end
      end
    end
  end
end
