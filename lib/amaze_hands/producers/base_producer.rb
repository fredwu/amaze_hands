module Producers
  class BaseProducer
    attr_reader :intel, :from_year, :from_week

    def initialize(intel, measure_every:, start_date:)
      @intel     = intel
      @from_year = start_date.year
      @from_week = start_date.cweek
    end
  end
end
