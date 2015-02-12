module Strategies
  module LeanKit
    module Transformers
      class Title
        attr_reader :card_type, :title

        def initialize(input)
          if match = input.match(/\[C\] (.*)/)
            @card_type = :capability
            @title     = match[1]
          else
            @card_type = :bau
            @title     = input
          end
        end
      end
    end
  end
end
