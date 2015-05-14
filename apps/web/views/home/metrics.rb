module Web::Views::Home
  class Metrics
    include Web::View

    WEEK_FREQUENCY = 2

    def render
      raw Web::Presenters::JSONPresenter.new(
        Workflow.new(
          strategy: Strategies::LeanKit,
          lanes:    Strategies::LeanKit::PricingLanes,
          files:    Dir["#{Web::Application.configuration.root}/../../db/pricing/*.txt"]
        )
      ).metrics(
        measure_every: WEEK_FREQUENCY.weeks
      )
    end
  end
end
