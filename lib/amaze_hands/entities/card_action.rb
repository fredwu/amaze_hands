class CardAction
  include Lotus::Entity

  attributes :date_time,
             :description,
             :analysable,
             :card_number

  def lane_movement?
    description.key?(:from)
  end
end
