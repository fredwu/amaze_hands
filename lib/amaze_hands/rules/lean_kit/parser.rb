module Rules
  module LeanKit
    class Parser < Rules::BaseParser
      rule(:no_value)     { str('<no value>') }

      rule(:created_by)   { ((created_text | newline).absent? >> any).repeat(1) }
      rule(:created_text) { str(' created this Card within the ') }
      rule(:created_in)   { ((created_lane | newline).absent? >> any).repeat(1).as(:created_in) }
      rule(:created_lane) { str(' Lane.') }

      rule(:moved_by)     { ((moved_text | newline).absent? >> any).repeat(1) }
      rule(:moved_text)   { str(' moved this Card from ') }
      rule(:moved_from)   { ((to | newline).absent? >> any).repeat(1).as(:from) }
      rule(:moved_to)     { line_text.as(:to) }

      rule(:service_text) { str('Class of Service: from ') }
      rule(:service_from) { (quote >> quoted_text.as(:service_from) >> quote) | no_value.as(:service_from) }
      rule(:service_to)   { (quote >> quoted_text.as(:service_to) >> quote) | no_value.as(:service_to) }

      rule(:created)      { created_by >> created_text >> created_in >> created_lane }
      rule(:moved)        { moved_by >> moved_text >> moved_from >> to >> moved_to }
      rule(:service)      { indentation? >> service_text >> service_from >> to >> service_to }

      rule(:timestamp)    { date.as(:date) >> at >> time.as(:time) >> newline }
      rule(:description)  { ((created | moved | service | line_text) >> newline) | empty_line }

      rule(:action)       { timestamp.as(:timestamp) >> (timestamp.absent? >> description).repeat.as(:description) }
      rule(:actions)      { action.as(:action).repeat }

      root(:actions)
    end
  end
end
