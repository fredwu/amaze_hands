module Strategies
  module CSV
    class TimeMaths
      def formula(card_action, next_card_action)
        (next_card_action.date_time.to_date - card_action.date_time.to_date).to_i
      end
    end
  end
end
