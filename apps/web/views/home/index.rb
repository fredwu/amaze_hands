module Web::Views::Home
  class Index
    include Web::View

    def frequency
      Web::Views::Home::Metrics::WEEK_FREQUENCY
    end
  end
end
