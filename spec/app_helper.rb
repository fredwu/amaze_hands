require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# Require this file for unit tests
ENV['LOTUS_ENV'] ||= 'test'

require_relative '../config/environment'

require 'pry'

Lotus::Application.preload!

Dir["#{__dir__}/{support,factories}/**/*.rb"].each { |f| require f }

module Fixture
  def self.read(filename)
    Pathname.new(Dir.pwd).join('spec/fixtures', filename).read
  end
end

RSpec.configure do |config|
  config.before do
    CardRepository.clear
    CardActionRepository.clear
    CardLaneRepository.clear
  end
end
