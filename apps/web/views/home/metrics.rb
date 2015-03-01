module Web::Views::Home
  class Metrics
    include Web::View

    def render
      Web::Presenters::JSONPresenter.new(
        Workflow.new(
          strategy: Strategies::LeanKit,
          files: Dir["#{Web::Application.configuration.root}/../../db/cards/*.txt"]
        )
      ).metrics
    end
  end
end
