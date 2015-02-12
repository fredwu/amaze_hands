require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# Require this file for unit tests
ENV['LOTUS_ENV'] ||= 'test'

require_relative '../config/environment'

require 'pry'

Lotus::Application.preload!

Dir[File.expand_path(File.join('spec/support/**/*.rb'))].each { |f| require f }

module Fixture
  def self.read(filename)
    Pathname.new(Dir.pwd).join('spec/fixtures', filename).read
  end
end
