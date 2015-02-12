module Strategies
  module LeanKit
    module Transformers
      class ServiceLabel
        attr_reader :transformed

        def initialize(input)
          if input == '<no value>' || input.nil?
            @transformed = ''
          else
            @transformed = input
          end
        end
      end
    end
  end
end
