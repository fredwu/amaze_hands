require_relative 'base'

module Builders
  class CardActions < Base
    def build_with(actions_attributes)
      actions_attributes.each do |action_attributes|
        Builders::CardAction.new(card).build_with(action_attributes)
      end
    end
  end
end
