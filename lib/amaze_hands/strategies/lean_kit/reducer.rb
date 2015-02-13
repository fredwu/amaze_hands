Dir[File.expand_path(File.join('reducers/**/*.rb'))].each { |f| require f }

module Strategies
  module LeanKit
    class Reducer
      attr_reader :card, :card_actions

      def initialize(card)
        @card         = card
        @card_actions = CardActionRepository.all_by_card(card)
      end

      def tag
        tag_lane_movement_actions(card_actions)
      end

      private

      def tag_lane_movement_actions(card_actions)
        Reducers::LaneMovement.new(card_actions).tag
      end
    end
  end
end
