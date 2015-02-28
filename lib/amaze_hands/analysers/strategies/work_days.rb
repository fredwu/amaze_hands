module Analysers
  module Strategies
    module WorkDays
      def formula(card_action, next_card_action)
        super.tap do |days|
          return days - non_working_days(card_action, next_card_action)
        end
      end

      private

      def non_working_days(card_action, next_card_action)
        (card_action.date_time..next_card_action.date_time).reject(&:business_day?).length
      end
    end
  end
end
