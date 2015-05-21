module Web::Views::Home
  class Metrics
    include Web::View

    WEEK_FREQUENCY = 2

    def render
      raw Web::Presenters::JSONPresenter.new(
        Workflow.new(workflow_params)
      ).metrics(
        measure_every: WEEK_FREQUENCY.weeks
      )
    end

    private

    def workflow_params
      send :"workflow_params_for_#{params[:name]}"
    end

    def workflow_params_for_customers
      {
        strategy: Strategies::LeanKit,
        lanes:    Strategies::LeanKit::CustomersLanes,
        files:    Dir["#{Web::Application.configuration.root}/../../db/customers/*.txt"]
      }
    end

    def workflow_params_for_pricing
      {
        strategy: Strategies::LeanKit,
        lanes:    Strategies::LeanKit::PricingLanes,
        files:    Dir["#{Web::Application.configuration.root}/../../db/pricing/*.txt"]
      }
    end

    def workflow_params_for_products
      {
        strategy: Strategies::CSV,
        lanes:    Strategies::CSV::Lanes,
        files:    Dir["#{Web::Application.configuration.root}/../../db/products/*.csv"]
      }
    end
  end
end
