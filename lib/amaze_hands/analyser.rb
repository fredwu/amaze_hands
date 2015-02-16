Dir["#{__dir__}/analysers/**/*.rb"].each { |f| require f }

class Analyser
  attr_reader :card, :card_actions

  def initialize(card)
    @card         = card
    @card_actions = CardActionRepository.analysable_by_card(card)
  end

  def analyse
    Analysers::WaitDays.new(card_actions).analyse
    Analysers::CalendarYearWeek.new(card_actions).analyse
  end
end
