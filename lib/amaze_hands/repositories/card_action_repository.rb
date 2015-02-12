class CardActionRepository
  include Lotus::Repository

  def self.filter_by_card(card)
    query { where(card_number: card.number) }
  end
end
