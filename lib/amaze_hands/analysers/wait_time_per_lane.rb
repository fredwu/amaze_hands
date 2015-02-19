require_relative 'base'

module Analysers
  class WaitTimePerLane < Base
    def analyse
      Strategies::TimeUntilNextMovement.new(
        type:                    :wait_time,
        card_actions:            card_actions,
        apply_against_next_lane: true,
        time_maths:              TimeMaths.new
      ).apply_on(
        ready_for_pulling_card_actions
      )
    end

    private

    def ready_for_pulling_card_actions
      card_actions.to_a.select { |action| action.description[:ready] == true }
    end

    class TimeMaths
      def formula(card_action, next_card_action)
        (next_card_action.date_time.to_date - card_action.date_time.to_date).to_f
      end
    end
  end
end
