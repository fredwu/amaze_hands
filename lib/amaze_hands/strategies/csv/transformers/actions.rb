require_relative 'date_time'

module Strategies
  module CSV
    module Transformers
      class Actions
        attr_reader :transformed, :date

        def initialize(actions, date:)
          @date = date

          actions.inject(nil) do |last_action, action|
            process_action(action, last_action)
          end

          @transformed = actions
        end

        private

        def process_action(action, last_action)
          action[:description] = {}

          if last_action.nil?
            process_first_action(action)
          elsif action[:to].to_s =~ /Blocked/
            process_block_action(action, last_action)
          else
            process_normal_action(action, last_action)
          end

          action[:time]      = "09:30:00 AM"
          action[:date_time] = DateTime.new(action[:date], action[:time]).transformed

          action.delete(:to)
          action
        end

        def process_first_action(action)
          action[:date]               = date
          action[:description][:from] = 'In Analysis'
          action[:description][:to]   = action[:to]
        end

        def process_normal_action(action, last_action)
          action[:date]               = Duration.new(last_action).transformed
          action[:description][:from] = last_action[:description][:ready_from]
          action[:description][:to]   = action[:to]
        end

        def process_block_action(action, last_action)
          action[:date]                     = Duration.new(last_action).transformed
          action[:description][:ready]      = true
          action[:description][:ready_from] = last_action[:description][:to]
        end

        class Duration
          attr_reader :transformed

          def initialize(action)
            @transformed = (::Date.parse(action[:date]) + action[:days].to_i).strftime('%d/%m/%Y')
          end
        end
      end
    end
  end
end
