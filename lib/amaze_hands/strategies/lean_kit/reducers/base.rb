module Strategies
  module LeanKit
    module Reducers
      class Base
        attr_reader :card_actions

        def initialize(card_actions)
          @card_actions = card_actions
        end

        def tag
          card_actions_to_tag.each do |card_action|
            card_action.analysable = true
            CardActionRepository.update(card_action)
          end
        end

        private

        def card_actions_to_tag
          card_actions.all.select do |card_action|
            tag_card_action(card_action)
          end
        end

        def tag_card_action(card_action)
          raise NotImplementedError
        end
      end
    end
  end
end
