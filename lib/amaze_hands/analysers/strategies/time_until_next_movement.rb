module Analysers
  module Strategies
    class TimeUntilNextMovement
      attr_reader :type, :card_actions, :time_maths

      def initialize(type:, card_actions:, time_maths:)
        @type         = type
        @card_actions = card_actions
        @time_maths   = time_maths
      end

      def apply_on(card_actions)
        card_actions.each do |card_action|
          record_time_until_next_movement(card_action)
        end
      end

      private

      def record_time_until_next_movement(card_action)
        return unless next_card_action = next_movement_card_action(card_action)

        entity = CardLaneRepository.find_or_create(
          card_number: card_action.card_number,
          lane:        next_card_action.description[:from]
        )

        time = time_maths.formula(card_action, next_card_action)

        entity.send("#{type}=", entity.send(type) + time)

        CardLaneRepository.update(entity)
      end

      def next_movement_card_action(card_action)
        card_actions_in_future(card_action).detect do |action|
          action.description.key?(:from) &&
            (
              !card_action.description.key?(:to) ||
                card_action.description[:to] == action.description[:from]
            )
        end
      end

      def card_actions_in_future(card_action)
        card_actions.drop_while { |action| action != card_action }[1..-1]
      end
    end
  end
end
