collection :cards do
  entity Card

  attribute :id,     Integer
  attribute :number, String
  attribute :type,   Symbol
  attribute :title,  String
end

collection :card_actions do
  entity CardAction

  attribute :id,          Integer
  attribute :date_time,   DateTime
  attribute :description, Hash
  attribute :analysable,  Boolean
  attribute :card_number, String
end
