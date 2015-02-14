class CardLaneRepository
  include Lotus::Repository

  def self.find_or_create(conditions)
    query { where(conditions) }.first || create(CardLane.new(conditions))
  end
end
