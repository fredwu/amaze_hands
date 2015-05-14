require 'csv'

module Strategies
  module CSV
    class PreProcessor
      def process(files)
        process_line_items(files.first)
      end

      private

      def process_line_items(input)
        index = 0
        ::CSV.read(input, headers: true).map do |item|
          process_line_item(item, index: (index += 1))
        end
      end

      def process_line_item(item, index:)
        file_path = File.join(AmazeHands.root, 'tmp', "#{index}.txt")

        File.write(file_path, process_line_item_content(item, index: index))

        file_path
      end

      def process_line_item_content(item, index:)
        <<-INPUT
Card ID: #{index}
Start Date: #{item['Start Date']} 00:00:00 AM
Type: #{item['Type']}
In Dev: #{item['In Dev']}
In Dev Blocked: #{item['In Dev Blocked']}
In QA: #{item['In QA']}
In QA Blocked: #{item['In QA Blocked']}
In BAT: #{item['In BAT']}
In BAT Blocked: #{item['In BAT Blocked']}
In Deployment: #{item['In Deployment']}
In Deployment Blocked: #{item['In Deployment Blocked']}
        INPUT
      end
    end
  end
end
