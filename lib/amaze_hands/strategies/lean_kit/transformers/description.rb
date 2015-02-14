module Strategies
  module LeanKit
    module Transformers
      class Description
        attr_reader :transformed

        def initialize(input)
          if input.is_a?(Array)
            @transformed = transform_nodes(input)
          else
            @transformed = input
          end
        end

        private

        def transform_nodes(nodes)
          transformed_nodes = nodes.each_with_object({}) do |item, items|
            construct_nodes_for(item, items)
          end

          remove_redundant_text_node(transformed_nodes)

          transformed_nodes
        end

        def construct_nodes_for(item, items)
          key   = item.keys.first
          value = item.values.first

          if key == :text
            items[key] ||= []
            items[key] << value
          else
            items.merge!(item)
          end
        end

        def remove_redundant_text_node(nodes)
          nodes.delete(:text) unless nodes.keys == [:text]
        end
      end
    end
  end
end
