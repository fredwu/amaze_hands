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
      card_actions.to_a.select { |action| action.description.key?(:from) || action.description.key?(:created_in) }
    end

    class TimeMaths
      def formula(card_action, next_card_action)
        return 0 unless next_card_action

        full_days = next_card_action.date_time.to_date - card_action.date_time.to_date

        if full_days.zero?
          duration_same_day(card_action, next_card_action)
        else
          duration_multi_day(card_action, next_card_action, full_days)
        end
      end

      private

      def duration_multi_day(card_action, next_card_action, full_days)
        partial_day_head = card_action.date_time.strftime('%p')      == 'AM' ? 1.0 : 0.5
        partial_day_tail = next_card_action.date_time.strftime('%p') == 'PM' ? 1.0 : 0.5

        partial_day_head + (full_days - 1.0) + partial_day_tail
      end

      def duration_same_day(card_action, next_card_action)
        if card_action.date_time.strftime('%p') == 'AM' && next_card_action.date_time.strftime('%p') == 'PM'
          1.0
        else
          0.5
        end
      end
    end
  end
end
