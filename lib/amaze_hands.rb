require 'lotus/model'
Dir["#{ __dir__ }/amaze_hands/**/*.rb"].each { |file| require_relative file }

Lotus::Model.configure do
  # Database adapter
  #
  # Available options:
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/amaze_hands_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/amaze_hands_development.db'
  #    adapter type: :sql, uri: 'postgres://localhost/amaze_hands_development'
  #    adapter type: :sql, uri: 'mysql://localhost/amaze_hands_development'
  #
  adapter type: :file_system, uri: ENV['AMAZE_HANDS_DATABASE_URL']

  ##
  # Database mapping
  #
  # You can specify mapping file to load with:
  #
  # mapping "#{__dir__}/config/mapping"
  #
  # Alternatively, you can use a block syntax like the following:
  #
  mapping do
    # collection :users do
    #   entity     User
    #   repository UserRepository
    #
    #   attribute :id,   Integer
    #   attribute :name, String
    # end
  end
end.load!
