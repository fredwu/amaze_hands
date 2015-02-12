module Strategies
  module LeanKit
    module Transformers
      class Description
        attr_reader :transformed

        def initialize(input)
          if input.is_a?(Array)
            @transformed = transform_array(input)
          else
            @transformed = input
          end
        end

        private

        def transform_array(input)
          input.each_with_object({}) do |item, items|
            key   = item.keys.first
            value = item.values.first

            if key == :text
              items[key] ||= []
              items[key] << value
            else
              items.merge!(item)
            end
          end
        end
      end
    end
  end
end
