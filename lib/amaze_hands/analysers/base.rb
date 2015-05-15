Dir["#{__dir__}/strategies/**/*.rb"].each { |f| require f }

module Analysers
  class Base
    attr_reader :card_actions

    def initialize(card_actions = [], *options)
      @card_actions = card_actions
    end
  end
end
