require_relative 'base'
require_relative 'cycle_time_per_lane'

module Analysers
  class CycleTime < Base
    def analyse
      CardRepository.all.each do |card|
        analyse_cycle_time_of(card)
      end
    end

    private

    def analyse_cycle_time_of(card)
      actions = movement_card_actions(card)

      card.cycle_time = CycleTimePerLane::TimeMaths.new.formula(actions.first, actions.last)

      CardRepository.update(card)
    end

    def movement_card_actions(card)
      card_actions.to_a.select { |action| action.description.key?(:from) }
    end

    class TimeMaths
      def formula(card_action, next_card_action)
        ((next_card_action.date_time - card_action.date_time) * 2).round / 2.0
      end
    end
  end
end
