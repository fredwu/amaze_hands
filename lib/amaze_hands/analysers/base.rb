module Analysers
  class Base
    attr_reader :card_actions

    def initialize(card_actions)
      @card_actions = card_actions
    end
  end
end
