module Web::Controllers::Home
  class Metrics
    include Web::Action

    def call(params)
      self.format = :json
    end
  end
end
