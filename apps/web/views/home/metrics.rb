module Web::Views::Home
  class Metrics
    include Web::View

    WEEK_FREQUENCY = 2

    def render
      Web::Presenters::JSONPresenter.new(
        Workflow.new(
          # strategy: Strategies::LeanKit,
          # lanes:    Strategies::LeanKit::PricingLanes,
          # files:    Dir["#{Web::Application.configuration.root}/../../db/pricing/*.txt"]
          strategy: Strategies::CSV,
          lanes:    Strategies::CSV::Lanes,
          files:    Dir["#{Web::Application.configuration.root}/../../db/products/*"]
        )
      ).metrics(
        measure_every: WEEK_FREQUENCY.weeks
      )
    end
  end
end
