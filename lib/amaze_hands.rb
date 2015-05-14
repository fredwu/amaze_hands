require 'active_support/all'
require 'parslet'
require 'parslet/convenience'
require 'descriptive-statistics'
require 'biz'
require 'biz/core_ext'
require 'lotus/model'

require_relative 'config/work_days'

module AmazeHands
  def self.root
    File.join(__dir__, '..')
  end
end

Dir["#{__dir__}/amaze_hands/debuggers/**/*.rb"].each { |f| require f }
Dir["#{__dir__}/amaze_hands/**/*.rb"].each { |f| require f }

Lotus::Model.configure do
  adapter type: :memory, uri: 'memory://localhost/amaze_hands'
  mapping "#{__dir__}/config/mapping"
end.load!

Dir["#{__dir__}/monkey_patches/**/*.rb"].each { |f| require f }
