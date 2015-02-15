require_relative 'base'

module Reducers
  class Readiness < Base
    private

    def tag_card_action(card_action)
      card_action.description[:ready] == true &&
        (card_action.date_time > card_actions.detect(&:analysable).date_time)
    end
  end
end
