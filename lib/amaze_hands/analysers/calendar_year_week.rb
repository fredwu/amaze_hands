require_relative 'base'

module Analysers
  class CalendarYearWeek < Base
    def analyse
      year = first_card_action_date_time.year
      week = first_card_action_date_time.cweek

      CardLaneRepository.all.each do |card_lane|
        card_lane.year = year
        card_lane.week = week

        CardLaneRepository.update(card_lane)
      end
    end

    private

    def first_card_action_date_time
      @first_card_action_date_time ||= card_actions.first.date_time
    end
  end
end
