module Strategies
  module LeanKit
    class WorkDays
      def holiday_days_on_week_days
        %w(
          18-02-2015
          19-02-2015
          20-02-2015
          23-02-2015
          24-02-2015
        )
      end

      def work_days_on_weekends
        %w(
          15-02-2015
          28-02-2015
        )
      end
    end
  end
end
