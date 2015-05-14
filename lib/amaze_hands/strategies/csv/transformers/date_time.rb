module Strategies
  module CSV
    module Transformers
      class DateTime
        TIME_ZONE        = '+1000'
        TIMESTAMP_FORMAT = '%d/%m/%Y %H:%M:%S %P %z'

        attr_reader :transformed

        def initialize(date, time)
          @transformed = ::DateTime.strptime("#{date} #{time} #{TIME_ZONE}", TIMESTAMP_FORMAT)
        end
      end
    end
  end
end
