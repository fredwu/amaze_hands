require_relative '../base_parser'

module Parsers
  module LeanKit
    class Parser < Parsers::BaseParser
      rule(:card_number)    { (str('P-') >> digit.repeat(3)).as(:card_number) }
      rule(:no_value)       { str('<no value>') }

      rule(:created_by)     { ((created_text | newline).absent? >> any).repeat(1) }
      rule(:created_text)   { str(' created this Card within the ') }
      rule(:created_in)     { ((created_lane | newline).absent? >> any).repeat(1).as(:created_in) }
      rule(:created_lane)   { str(' Lane.') }
      rule(:created)        { created_by >> created_text >> created_in >> created_lane }

      rule(:moved_by)       { ((moved_text | newline).absent? >> any).repeat(1) }
      rule(:moved_text)     { str(' moved this Card from ') }
      rule(:moved_from)     { ((to | newline).absent? >> any).repeat(1).as(:from) }
      rule(:moved_to)       { line_text.as(:to) }
      rule(:moved)          { moved_by >> moved_text >> moved_from >> to >> moved_to }

      rule(:service_text)   { str('Class of Service: from ') }
      rule(:service_from)   { (quote >> quoted_text.as(:service_from) >> quote) | no_value.as(:service_from) }
      rule(:service_to)     { (quote >> quoted_text.as(:service_to) >> quote) | no_value.as(:service_to) }
      rule(:service)        { indentation? >> service_text >> service_from >> to >> service_to }

      rule(:blocked_by)     { ((blocked_text | newline).absent? >> any).repeat(1) }
      rule(:blocked_text)   { str(' set the status of this Card to ') }
      rule(:blocked_status) { (str('Blocked') | str('Unblocked')).as(:blocked_status) }
      rule(:blocked)        { blocked_by >> blocked_text >> blocked_status }

      rule(:title)          { card_number >> space >> line_text.as(:title) >> newline }
      rule(:timestamp)      { date.as(:date) >> at >> time.as(:time) >> newline }
      rule(:description)    { ((created | moved | service | blocked | line_text) >> newline) | empty_line }

      rule(:action)         { timestamp.as(:timestamp) >> (timestamp.absent? >> description).repeat.as(:description) }
      rule(:actions)        { title >> empty_line >> action.as(:action).repeat }

      root(:actions)
    end
  end
end
