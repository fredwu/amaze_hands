class CardRepository
  include Lotus::Repository

  def self.find(number)
    query { where(number: number) }.first
  end
end
