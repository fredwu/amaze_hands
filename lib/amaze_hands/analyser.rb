Dir["#{__dir__}/analysers/**/*.rb"].each { |f| require f }

class Analyser
  include Debuggers::Benchmark
  benchmark_on :initialize, :analyse

  attr_reader :card, :card_actions, :time_maths

  def initialize(card, time_maths: nil)
    @card         = card
    @card_actions = CardActionRepository.analysable_by_card(card)
    @time_maths   = time_maths
  end

  def analyse
    Analysers::CycleTimePerLane.new(card_actions, time_maths: time_maths).analyse
    Analysers::WaitTimePerLane.new(card_actions, time_maths: time_maths).analyse
    Analysers::CycleTime.new(card_actions).analyse
    Analysers::WaitTime.new.analyse
    Analysers::CalendarYearWeek::ForCardLane.new(card_actions).analyse
    Analysers::CalendarYearWeek::ForCard.new.analyse
  end
end
