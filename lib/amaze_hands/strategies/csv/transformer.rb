Dir["#{__dir__}/transformers/**/*.rb"].each { |f| require f }

module Strategies
  module CSV
    class Transformer < Parslet::Transform
      rule(
        card_number: simple(:card_number),
        date:        simple(:date),
        time:        simple(:time),
        card_type:   simple(:card_type),
        actions:     subtree(:actions)
      ) do
        {
          card_number: card_number,
          card_type:   card_type,
          title:       card_number,
          actions:     Transformers::Actions.new(actions, date: date, time: time).transformed
        }
      end
    end
  end
end
