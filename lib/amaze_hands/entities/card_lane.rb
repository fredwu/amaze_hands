class CardLane
  include Lotus::Entity

  attributes :card_number,
             :year,
             :week,
             :lane,
             :wait_time,
             :cycle_time

  def wait_time
    @wait_time || 0
  end

  def cycle_time
    @cycle_time || 0
  end
end
