Dir[File.expand_path(File.join('builders/**/*.rb'))].each { |f| require f }

module Strategies
  module LeanKit
    class Builder
      attr_reader :ast, :card

      def initialize(ast)
        @ast  = ast
        @card = Card.new
      end

      def build
        build_foundation

        CardRepository.create(card)
      end

      private

      def build_foundation
        Builders::Foundation.new(card).build_with(ast.slice(:card_number, :card_type, :title))
      end
    end
  end
end
