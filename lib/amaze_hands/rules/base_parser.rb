require 'parslet'
require 'parslet/convenience'

module Rules
  class BaseParser < Parslet::Parser
    rule(:digit)        { match('\\d') }
    rule(:fs)           { str('/') }
    rule(:colon)        { str(':') }
    rule(:quote)        { str('"') }
    rule(:space)        { match('\\s') }
    rule(:space?)       { space.maybe }
    rule(:indentation?) { space.repeat(0, 4) }
    rule(:newline)      { match('\\n') }
    rule(:newline?)     { newline.maybe }
    rule(:empty_line)   { newline }
    rule(:eof)          { any.absent? }

    rule(:am)           { str('AM') }
    rule(:pm)           { str('PM') }
    rule(:am_pm)        { am | pm }

    rule(:at)           { str(' at ') }
    rule(:to)           { str(' to ') }

    rule(:date)         { digit.repeat(2) >> fs >> digit.repeat(2) >> fs >> digit.repeat(4) }
    rule(:time)         { digit.repeat(2) >> colon >> digit.repeat(2) >> colon >> digit.repeat(2) >> space >> am_pm }

    rule(:quoted_text)  { (quote.absent? >> any).repeat(1) | (quote.absent? >> any).maybe }
    rule(:line_text)    { (newline.absent? >> any).repeat(1) }
  end
end
