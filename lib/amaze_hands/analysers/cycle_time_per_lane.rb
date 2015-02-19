require_relative 'base'

module Analysers
  class CycleTimePerLane < Base
    def analyse
      Strategies::TimeUntilNextMovement.new(
        type:         :cycle_time,
        card_actions: card_actions,
        time_maths:   TimeMaths.new
      ).apply_on(
        movement_card_actions
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

          full_days = next_movement.date_time.to_date - card_action.date_time.to_date

          if full_days.zero?
            if card_action.date_time.strftime('%p') == 'AM' && next_movement.date_time.strftime('%p') == 'PM'
              1.0
            else
              0.5
            end
          else
            partial_day_head = card_action.date_time.strftime('%p')   == 'AM' ? 1.0 : 0.5
            partial_day_tail = next_movement.date_time.strftime('%p') == 'PM' ? 1.0 : 0.5

            partial_day_head + (full_days - 1.0) + partial_day_tail
          end
        end
      end
    end
  end
end
