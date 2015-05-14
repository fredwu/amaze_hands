require_relative '../base_parser'

module Strategies
  module CSV
    class Parser < Strategies::BaseParser
      rule(:card_number) { str('Card ID: ') >> digit.repeat.as(:card_number) >> newline }
      rule(:timestamp)   { str('Start Date: ') >> date.as(:date) >> newline }
      rule(:card_type)   { str('Type: ') >> alpha.repeat.as(:card_type) >> newline }

      rule(:action_name) { (str('In ') >> alpha.repeat).as(:to) >> colon }
      rule(:action_days) { digit.repeat.as(:days) >> newline }

      rule(:action)      { action_name >> space >> action_days }
      rule(:actions)     { card_number >> timestamp >> card_type >> action.repeat.as(:actions) }

      root(:actions)
    end
  end
end
