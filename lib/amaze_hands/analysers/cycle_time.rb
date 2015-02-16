require_relative 'base'

module Analysers
  class CycleTime < Base
    def analyse
      Strategies::TimeUntilNextMovement.new(
        :cycle_time, card_actions
      ).apply_on(
        movement_card_actions, time_maths: TimeMaths.new
      )
    end

    private

    def movement_card_actions
      card_actions.to_a.select { |action| action.description.key?(:from) }
    end

    class TimeMaths
      def formula(card_action)
        -> do
          return 0 unless next_movement = next_movement_card_action(card_action)

          ((next_movement.date_time - card_action.date_time) * 1.second).to_i + 1
        end
      end
    end
  end
end
