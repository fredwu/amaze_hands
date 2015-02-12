Dir[File.expand_path(File.join('transformers/**/*.rb'))].each { |f| require f }

module Strategies
  module LeanKit
    class Transformer < Parslet::Transform
      rule(date: simple(:date), time: simple(:time)) do
        Transformers::DateTime.new(date, time).transformed
      end

      rule(timestamp: simple(:date_time), description: subtree(:description)) do
        {
          date_time:   date_time,
          description: Transformers::Description.new(description).transformed
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
