require_relative 'base'

module Analysers
  module CalendarYearWeek
    class ForCardLane < Base
      def analyse
        CardLaneRepository.all_by_card_number(card_number).each do |card_lane|
          card_lane.year = date_time.year
          card_lane.week = date_time.cweek

          CardLaneRepository.update(card_lane)
        end
      end

      private

      def card_number
        @card_number ||= card_actions.first.card_number
      end

      def date_time
        @date_time ||= card_actions.first.date_time
      end
    end

    class ForCard
      def analyse
        CardRepository.all.each do |card|
          first_card_lane = CardLaneRepository.all_by_card_number(card.number).first

          card.year = first_card_lane.year
          card.week = first_card_lane.week

          CardRepository.update(card)
        end
      end
    end
  end
end
