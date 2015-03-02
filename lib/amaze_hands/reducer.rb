Dir["#{__dir__}/reducers/**/*.rb"].each { |f| require f }

class Reducer
  include Debuggers::Benchmark
  benchmark_on :initialize, :tag

  attr_reader :card, :card_actions

  def initialize(card, lanes:)
    @card         = card
    @card_actions = CardActionRepository.all_by_card(card)
    @lanes        = lanes
  end

  def tag
    Reducers::LaneMovement.new(card_actions, lanes: @lanes).tag
    Reducers::Readiness.new(card_actions).tag
  end
end
