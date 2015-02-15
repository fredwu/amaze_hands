class CardLaneRepository
  include Lotus::Repository

  def self.find_or_create(conditions)
    conditions.inject(query) do |chain, condition|
      chain.where(condition)
    end.first || create(CardLane.new(conditions))
  end
end
