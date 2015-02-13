require_relative 'base'
require_relative '../builders/card_action'

module Strategies
  module LeanKit
    module Reducers
      class LaneMovement < Base
        LANES_ANALYSABLE_INITIAL = [
          'Doing: Capability',
          'Doing: BAU'
        ]

        LANES_ANALYSABLE_IN_PROGRESS = [
          'QA',
          'BAT'
        ]

        LANES_ANALYSABLE_FINAL = [
          'Done'
        ]

        LANES_ANALYSABLE = [
          *LANES_ANALYSABLE_INITIAL,
          *LANES_ANALYSABLE_IN_PROGRESS,
          *LANES_ANALYSABLE_FINAL
        ]

        LANES_NON_ANALYSABLE_INITIAL = Builders::CardAction::LANES_NON_ANALYSABLE_INITIAL
        LANES_NON_ANALYSABLE_FINAL   = Builders::CardAction::LANES_NON_ANALYSABLE_FINAL

        private

        def tag_card_action(card_action)
          tag_created_in(card_action) || tag_moved(card_action)
        end

        def tag_created_in(card_action)
          card_action.description.key?(:created_in) &&
            card_action.description[:created_in].in?(LANES_ANALYSABLE)
        end

        # the only non-analysable actions are the ones moved
        # from NON_ANALYSABLE_INITIAL to LANES_ANALYSABLE_INITIAL
        # and from LANES_ANALYSABLE_FINAL to LANES_NON_ANALYSABLE_FINAL
        #
        # as seen in the graph below:
        #
        # C = card
        # O = analysable lane
        # X = non-analysable lane
        #
        # | X  O  O  O  X  | action analysable?
        # | -------------- |
        # | C-->           | yes
        # | <--C           | no
        # |          C-->  | no
        # |          <--C  | no
        # |    <--C        | yes
        # |       C-->     | yes
        # | <-----C        | yes
        # |       C----->  | yes
        # | <--------C     | yes
        # |    C-------->  | yes
        #
        def tag_moved(card_action)
          card_action.description.key?(:from) &&
            (moved_into_analysable_initials(card_action) || analysable_movements(card_action))
        end

        def analysable_movements(card_action)
          card_action.description[:from].in?(LANES_ANALYSABLE) &&
            !moved_out_of_analysable_initials(card_action) &&
            !moved_out_of_analysable_finals(card_action)
        end

        def moved_into_analysable_initials(card_action)
          card_action.description[:from].in?(LANES_NON_ANALYSABLE_INITIAL) &&
            card_action.description[:to].in?(LANES_ANALYSABLE_INITIAL)
        end

        def moved_out_of_analysable_initials(card_action)
          card_action.description[:from].in?(LANES_ANALYSABLE_INITIAL) &&
            card_action.description[:to].in?(LANES_NON_ANALYSABLE_INITIAL)
        end

        def moved_out_of_analysable_finals(card_action)
          card_action.description[:from].in?(LANES_ANALYSABLE_FINAL) &&
            card_action.description[:to].in?(LANES_NON_ANALYSABLE_FINAL)
        end
      end
    end
  end
end
