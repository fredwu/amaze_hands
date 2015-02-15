Dir["#{__dir__}/strategies/**/*.rb"].each { |f| require f }

require_relative 'builder'
require_relative 'reducer'
require_relative 'analyser'
require_relative 'producer'

class Workflow
  def initialize(strategy:, files: Dir["#{__dir__}/../../db/cards/*.txt"])
    files.each do |file|
      ast        = strategy::Parser.new.parse(File.new(file).read)
      common_ast = strategy::Transformer.new.apply(ast)
      card       = Builder.new(common_ast).build

      Reducer.new(card, lanes: strategy::Lanes).tag
      Analyser.new(card).analyse
    end
  end

  def metrics
    Producer.new.metrics
  end
end
