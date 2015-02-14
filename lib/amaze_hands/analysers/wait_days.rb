require_relative 'base'

module Analysers
  class WaitDays < Base
    def analyse
      card_actions.ready_for_pulling.each do |card_action|
        record_wait_days(card_action)
      end
    end

    private

    def record_wait_days(card_action)
      lane      = next_movement_card_action(card_action).description[:from]
      wait_days = calculate_wait_days(card_action)

      entity = CardLaneRepository.find_or_create(card_number: card_action.card_number, lane: lane)
      entity.wait_days += wait_days

      CardLaneRepository.update(entity)
    end

    def calculate_wait_days(card_action)
      ((next_movement_card_action(card_action).date_time - card_action.date_time) * 1.second).to_i
    end

    def next_movement_card_action(card_action)
      card_actions_in_future(card_action).detect(&:lane_movement?)
    end

    def card_actions_in_future(card_action)
      card_actions.drop_while { |action| action != card_action }[1..-1]
    end
  end
end
