require_relative 'base'

module Strategies
  module LeanKit
    module Reducers
      class ServiceLabelChange < Base
        SERVICE_LABEL_START = ''
        SERVICE_LABEL_READY = 'Expedite'

        SERVICE_LABELS = [SERVICE_LABEL_START, SERVICE_LABEL_READY]

        private

        def tag_card_action(card_action)
          card_action.description.key?(:service_from) &&
            (tag_ready_for_pull(card_action) || tag_pulled(card_action))
        end

        def tag_ready_for_pull(card_action)
          card_action.description[:service_from] == SERVICE_LABEL_START &&
            card_action.description[:service_to] == SERVICE_LABEL_READY
        end

        def tag_pulled(card_action)
          card_action.description[:service_from] == SERVICE_LABEL_READY &&
            card_action.description[:service_to] == SERVICE_LABEL_START
        end
      end
    end
  end
end
