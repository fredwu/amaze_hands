require_relative 'base'

module Strategies
  module LeanKit
    module Builders
      class CardAction < Base
        LANES_NON_ANALYSABLE_INITIAL = [
          'Triage: Triage',
          'Prioritised Backlog: Capability',
          'Prioritised Backlog: BAU',
          'In Analysis'
        ]

        LANES_NON_ANALYSABLE_FINAL = [
          'Archive: Pricing'
        ]

        LANES = [
          *LANES_NON_ANALYSABLE_INITIAL,
          'Doing: Capability',
          'Doing: BAU',
          'QA',
          'BAT',
          'Deploying',
          'Done',
          *LANES_NON_ANALYSABLE_FINAL
        ]

        SERVICES = ['', 'Expedite']

        def build_with(attributes)
          card_action             = ::CardAction.new
          card_action.date_time   = attributes[:date_time]
          card_action.description = attributes[:description]
          card_action.card_number = card.number

          CardActionRepository.create(card_action)
        end
      end
    end
  end
end
