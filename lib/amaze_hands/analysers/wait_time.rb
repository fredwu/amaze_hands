require_relative 'base'

module Analysers
  class WaitTime < Base
    def analyse
      Strategies::TimeUntilNextMovement.new(
        :wait_time, card_actions
      ).apply_on(
        ready_for_pulling_card_actions,
        apply_against_next_lane: true,
        time_maths:              TimeMaths.new
      )
    end

    private

    def ready_for_pulling_card_actions
      card_actions.to_a.select { |action| action.description[:ready] == true }
    end

    class TimeMaths
      def formula(card_action)
        -> do
          ((next_movement_card_action(card_action).date_time - card_action.date_time) * 1.second).to_i
        end
      end
    end
  end
end
