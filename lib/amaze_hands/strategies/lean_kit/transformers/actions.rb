module Strategies
  module LeanKit
    module Transformers
      class Actions
        attr_reader :transformed

        def initialize(actions)
          @transformed = actions.reverse
        end
      end
    end
  end
end
