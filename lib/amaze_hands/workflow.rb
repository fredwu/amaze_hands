Dir["#{__dir__}/strategies/**/*.rb"].each { |f| require f }

require_relative 'builder'
require_relative 'reducer'
require_relative 'analyser'
require_relative 'producer'

class Workflow
  def initialize(strategy:, files:)
    clean_up_db

    files.each do |file|
      ast        = strategy::Parser.new.parse(File.new(file).read)
      common_ast = strategy::Transformer.new.apply(ast)
      card       = Builder.new(common_ast).build

      Reducer.new(card, lanes: strategy::Lanes).tag
      Analyser.new(card).analyse
    end
  end

  def metrics(measure_every: 2.weeks, start_date: DateTime.parse('01-01-2015'))
    Producer.new(
      measure_every: measure_every,
      start_date:    start_date
    ).metrics
  end

  private

  def clean_up_db
    CardRepository.clear
    CardActionRepository.clear
    CardLaneRepository.clear
  end
end
