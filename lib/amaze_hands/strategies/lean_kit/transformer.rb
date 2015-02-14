Dir["#{__dir__}/transformers/**/*.rb"].each { |f| require f }

module Strategies
  module LeanKit
    class Transformer < Parslet::Transform
      rule(
        timestamp: {
          date: simple(:date),
          time: simple(:time)
        },
        description: subtree(:description)
      ) do
        {
          date:        date,
          time:        time,
          date_time:   Transformers::DateTime.new(date, time).transformed,
          description: Transformers::Description.new(description).transformed
        }
      end

      rule(
        service_from: simple(:service_from),
        service_to:   simple(:service_to)
      ) do
        {
          ready: Transformers::Readiness.new(
            Transformers::ServiceLabel.new(service_from).transformed,
            Transformers::ServiceLabel.new(service_to).transformed
          ).transformed
        }
      end

      rule(
        card_number: simple(:card_number),
        title:       simple(:title),
        actions:     subtree(:actions)
      ) do
        title_transformed = Transformers::Title.new(title)

        {
          card_number: card_number,
          card_type:   title_transformed.card_type,
          title:       title_transformed.title,
          actions:     Transformers::Actions.new(actions).transformed
        }
      end
    end
  end
end
