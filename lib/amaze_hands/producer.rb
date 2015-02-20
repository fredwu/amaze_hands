Dir["#{__dir__}/producers/**/*.rb"].each { |f| require f }

class Producer
  def initialize(*options)
    @intel   = Intelligence.new
    @options = options
  end

  def metrics
    Producers::CardLaneProducer.new(@intel, *@options).apply

    @intel
  end
end
