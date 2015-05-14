require_relative 'date_time'

module Strategies
  module CSV
    module Transformers
      class Actions
        attr_reader :transformed

        def initialize(actions, date:, time:)
          actions.inject(nil) do |last_action, action|
            last_action = process_action(action, last_action: last_action, date: date, time: time)
          end

          @transformed = actions
        end

        private

        def process_action(action, last_action:, date:, time:)
          action[:description] = {}

          if last_action.nil?
            action[:date]               = date
            action[:description][:from] = 'In Analysis'
            action[:description][:to]   = action[:to]
          elsif action[:to].to_s =~ /Blocked/
            action[:date]                = (::Date.parse(last_action[:date]) + action[:days].to_i).strftime('%d/%m/%Y')
            action[:description][:ready] = true
          else
            action[:date]               = (::Date.parse(last_action[:date]) + action[:days].to_i).strftime('%d/%m/%Y')
            action[:description][:from] = last_action[:to]
            action[:description][:to]   = action[:to]
          end

          action[:time]             = time
          action[:date_time]        = DateTime.new(action[:date], time).transformed

          action.delete(:days)
          action.delete(:to)
          action
        end
      end
    end
  end
end
