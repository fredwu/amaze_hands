module Strategies
  module LeanKit
    module Builders
      class Base
        attr_accessor :card

        def initialize(card)
          @card = card
        end
      end
    end
  end
end
