require_relative 'base'

module Builders
  class CardAction < Base
    def build_with(attributes)
      card_action             = ::CardAction.new
      card_action.date_time   = attributes[:date_time]
      card_action.description = attributes[:description]
      card_action.card_number = card.number

      CardActionRepository.create(card_action)
    end
  end
end
