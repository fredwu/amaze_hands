require_relative 'base'

module Strategies
  module LeanKit
    module Builders
      class CardAction < Base
        LANES = [
          'Triage: Triage',
          'Prioritised Backlog: Capability',
          'Prioritised Backlog: BAU',
          'In Analysis',
          'Doing: Capability',
          'Doing: BAU',
          'QA',
          'BAT',
          'Deploying',
          'Done'
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
