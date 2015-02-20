class Card
  include Lotus::Entity

  attributes :number,
             :type,
             :title,
             :year,
             :week,
             :cycle_time,
             :wait_time

  def wait_time
    @wait_time || 0
  end

  def cycle_time
    @cycle_time || 0
  end
end
