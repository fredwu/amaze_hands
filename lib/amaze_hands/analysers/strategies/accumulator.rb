module Analysers
  module Strategies
    class Accumulator
      attr_reader :type, :card_lanes

      def initialize(type:)
        @type       = type
        @card_lanes = CardLaneRepository.all
      end

      def apply
        card_lanes.group_by(&:card_number).each do |card_number, grouped_card_lanes|
          card = CardRepository.find(card_number)

          card.send("#{type}=", grouped_card_lanes.sum(&type))

          CardRepository.update(card)
        end
      end
    end
  end
end
