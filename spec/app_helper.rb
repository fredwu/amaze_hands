require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

# Require this file for unit tests
ENV['LOTUS_ENV'] ||= 'test'

require_relative '../config/environment'

require 'pry'

Lotus::Application.preload!

module Fixture
  def self.read(filename)
    Pathname.new(Dir.pwd).join('spec', 'fixtures', filename).read
  end
end
