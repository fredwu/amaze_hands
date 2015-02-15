require_relative 'base'

module Reducers
  class LaneMovement < Base
    attr_reader :lanes

    def initialize(card_actions, lanes:)
      super(card_actions)

      @lanes = lanes
    end

    private

    def tag_card_action(card_action)
      tag_created_in(card_action) || tag_moved(card_action)
    end

    def tag_created_in(card_action)
      card_action.description.key?(:created_in) &&
        card_action.description[:created_in].in?(lanes.with_traits(:analysable))
    end

    # the only non-analysable actions are the ones moved
    # from "non-analysable initial" to "analysable initial"
    # and from "analysable final" to "non-analysable final"
    #
    # as seen in the graph below:
    #
    # C = card
    # O = analysable lane
    # X = non-analysable lane
    #
    # | X  O  O  O  X | action analysable?
    # | ------------- |
    # | C-->          | no
    # | <--C          | no
    # |          C--> | no
    # |          <--C | no
    # |    <--C       | yes
    # |       C-->    | yes
    # | <-----C       | yes
    # |       C-----> | yes
    # | <--------C    | yes
    # |    C--------> | yes
    #
    def tag_moved(card_action)
      card_action.description.key?(:from) && analysable_movements(card_action)
    end

    def analysable_movements(card_action)
      card_action.description[:from].in?(lanes.with_traits(:analysable)) &&
        !moved_out_of_analysable_initials(card_action) &&
        !moved_out_of_analysable_finals(card_action)
    end

    def moved_out_of_analysable_initials(card_action)
      card_action.description[:from].in?(lanes.with_traits(:analysable, :initial)) &&
        card_action.description[:to].in?(lanes.with_traits(:non_analysable, :initial))
    end

    def moved_out_of_analysable_finals(card_action)
      card_action.description[:from].in?(lanes.with_traits(:analysable, :final)) &&
        card_action.description[:to].in?(lanes.with_traits(:non_analysable, :final))
    end
  end
end
