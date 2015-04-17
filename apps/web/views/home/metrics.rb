module Web::Views::Home
  class Metrics
    include Web::View

    WEEK_FREQUENCY = 1

    def render
      Web::Presenters::JSONPresenter.new(
        Workflow.new(
          strategy: Strategies::LeanKit,
          files: Dir["#{Web::Application.configuration.root}/../../db/cards/*.txt"]
        )
      ).metrics(
        measure_every: WEEK_FREQUENCY.weeks
      )
    end
  end
end
