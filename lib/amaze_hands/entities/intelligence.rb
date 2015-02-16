class Intelligence
  attr_accessor :cycle_time,
                :wait_time

  def initialize
    @cycle_time = {}
    @wait_time  = {}
  end
end
