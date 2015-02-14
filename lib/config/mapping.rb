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

collection :card_lanes do
  entity CardLane

  attribute :id,          Integer
  attribute :card_number, String
  attribute :lane,        String
  attribute :wait_days,   Integer
end
