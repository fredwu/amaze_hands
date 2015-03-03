Dir["#{__dir__}/producers/**/*.rb"].each { |f| require f }

class Producer
  include Debuggers::Benchmark
  benchmark_on :metrics

  def initialize(*options)
    @intel   = Intelligence.new
    @options = options
  end

  def metrics
    Producers::CardLaneProducer.new(@intel, *@options).apply
    Producers::CardProducer.new(@intel, *@options).apply
    Producers::RollingAverageProducer.new(@intel).apply
    Producers::StandardDeviationProducer.new(@intel).apply

    @intel
  end
end
