module Analysers
  module Strategies
    class TimeUntilNextMovement
      attr_reader :apply_to, :card_actions

      def initialize(apply_to, card_actions)
        @apply_to     = apply_to
        @card_actions = card_actions
      end

      def apply_on(card_actions, apply_against_next_lane: false, time_maths:)
        card_actions.each do |card_action|
          record_time_until_next_movement(
            card_action, apply_against_next_lane: apply_against_next_lane, time_maths: time_maths
          )
        end
      end

      private

      def record_time_until_next_movement(card_action, apply_against_next_lane:, time_maths:)
        if apply_against_next_lane
          applied_card_action = next_movement_card_action(card_action)
        else
          applied_card_action = card_action
        end

        entity = CardLaneRepository.find_or_create(
          card_number: card_action.card_number,
          lane:        applied_card_action.description[:from]
        )

        entity.send("#{apply_to}=", entity.send(apply_to) + instance_exec(&time_maths.formula(card_action)))

        CardLaneRepository.update(entity)
      end

      def next_movement_card_action(card_action)
        card_actions_in_future(card_action).detect(&:lane_movement?)
      end

      def card_actions_in_future(card_action)
        card_actions.drop_while { |action| action != card_action }[1..-1]
      end
    end
  end
end
