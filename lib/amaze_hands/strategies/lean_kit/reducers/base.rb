module Strategies
  module LeanKit
    module Reducers
      class Base
        attr_accessor :card_actions

        def initialize(card_actions)
          @card_actions = card_actions
        end
      end
    end
  end
end
