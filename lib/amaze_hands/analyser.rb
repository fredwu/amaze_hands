Dir["#{__dir__}/analysers/**/*.rb"].each { |f| require f }

class Analyser
  attr_reader :card, :card_actions

  def initialize(card)
    @card         = card
    @card_actions = CardActionRepository.analysable_by_card(card)
  end

  def analyse
    Analysers::CycleTimePerLane.new(card_actions).analyse
    Analysers::WaitTimePerLane.new(card_actions).analyse
    Analysers::CycleTime.new(card_actions).analyse
    Analysers::WaitTime.new.analyse
    Analysers::CalendarYearWeek::ForCardLane.new(card_actions).analyse
    Analysers::CalendarYearWeek::ForCard.new.analyse
  end
end
