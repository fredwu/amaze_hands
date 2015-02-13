require 'active_support/all'
require 'parslet'
require 'parslet/convenience'

require 'lotus/model'

Dir["#{ __dir__ }/amaze_hands/**/*.rb"].each { |file| require_relative file }

Lotus::Model.configure do
  adapter type: :memory, uri: 'memory://localhost/amaze_hands'
  mapping "#{__dir__}/config/mapping"
end.load!
