Dir["#{__dir__}/{strategies}/**/*.rb"].each { |f| require f }

require_relative 'builder'
require_relative 'reducer'
require_relative 'analyser'
require_relative 'producer'

class Workflow
  include Debuggers::Benchmark
  benchmark_on :initialize, :metrics, :clean_up_db

  def initialize(strategy:, lanes:, files:)
    clean_up_db

    files = strategy::PreProcessor.new.process(files)

    files.each do |file|
      ast        = strategy::Parser.new.parse(File.read(file))
      common_ast = strategy::Transformer.new.apply(ast)
      binding.pry
      card       = Builder.new(common_ast).build

      Reducer.new(card, lanes: lanes).tag
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
