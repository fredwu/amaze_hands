class CardAction
  include Lotus::Entity

  attributes :date_time,
             :description,
             :analysable,
             :card_number
end
