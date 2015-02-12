collection :cards do
  entity Card

  attribute :number, String
  attribute :type,   Symbol
  attribute :title,  String
end

collection :card_actions do
  entity CardAction

  attribute :date_time,   DateTime
  attribute :description, Hash
  attribute :card_number, String
end
