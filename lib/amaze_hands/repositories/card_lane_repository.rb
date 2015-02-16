class CardLaneRepository
  include Lotus::Repository

  def self.find_or_create(conditions)
    conditions.inject(query) do |chain, condition|
      chain.where(condition)
    end.first || create(CardLane.new(conditions))
  end

  def self.all_by_card_number(card_number)
    query { where(card_number: card_number) }
  end
end
