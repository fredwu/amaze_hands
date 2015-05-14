require 'lotus/helpers'
require 'slim'

module Web
  class Application < Lotus::Application
    configure do
      ##
      # BASIC
      #

      # Define the root path of this application.
      # All the paths specified in this configuration are relative to this one.
      #
      root __dir__

      # Relative load paths where this application will recursively load the code.
      # Remember to add directories here when you create new.
      #
      load_paths << %w(
        presenters
        controllers
        views
      )

      # Handle exceptions with HTTP statuses (true) or don't catch them (false).
      # Defaults to true.
      # See: http://www.rubydoc.info/gems/lotus-controller/#Exceptions_management
      #
      # handle_exceptions true

      ##
      # HTTP
      #

      # Routes definitions for this application
      # See: http://www.rubydoc.info/gems/lotus-router#Usage
      #
      routes 'config/routes'

      # URI scheme used by the routing system to generate absolute URLs
      # Defaults to "http"
      #
      # scheme 'https'

      # URI host used by the routing system to generate absolute URLs
      # Defaults to "localhost"
      #
      # host 'example.org'

      # URI port used by the routing system to generate absolute URLs
      # Argument: An object coercible to integer, default to 80 if the scheme is http and 443 if it's https
      # This SHOULD be configured only in case the application listens to that non standard ports
      #
      # port 443

      # Enable cookies
      #
      # cookies true

      # Enable sessions
      # Argument: Symbol the Rack session adapter
      #           A Hash with options
      #
      # See: http://www.rubydoc.info/gems/rack/Rack/Session/Cookie
      #
      # sessions :cookie, secret: ENV['WEB_SESSIONS_SECRET']

      # Configure Rack middleware for this application
      #
      # middleware.use Rack::Protection

      # Default format for the requests that don't specify an HTTP_ACCEPT header
      # Argument: A symbol representation of a mime type, default to :html
      #
      # default_format :html

      # HTTP Body parsers
      # Parse non GET responses body for a specific mime type
      # Argument: Symbol, which represent the format of the mime type (only `:json` is supported)
      #           Object, the parser
      #
      # body_parsers :json

      ##
      # DATABASE
      #

      # Configure a database adapter
      # Argument: A Hash with the settings
      #           type: Symbol, :file_system, :memory and :sql
      #           uri:  String, 'file:///db/bookshelf'
      #                         'memory://localhost/bookshelf'
      #                         'sqlite:memory:'
      #                         'sqlite://db/bookshelf.db'
      #                         'postgres://localhost/bookshelf'
      #                         'mysql://localhost/bookshelf'
      #
      # adapter type: :file_system, uri: ENV['WEB_DATABASE_URL']

      # Configure a database mapping
      # See: http://www.rubydoc.info/gems/lotus-model#Data_Mapper
      #
      # mapping 'config/mapping'

      ##
      # TEMPLATES
      #

      # The layout to be used by all the views
      #
      layout :application # It will load Web::Views::ApplicationLayout

      # The relative path where to find the templates
      #
      templates 'templates'

      ##
      # ASSETS
      #

      # Specify sources for assets
      # The directory `public/` is added by default
      #
      # assets << [
      #   'vendor/javascripts'
      # ]

      # Enabling serving assets
      # Defaults to false
      #
      # serve_assets false

      ##
      # FRAMEWORKS
      #

      # Configure the code to be yielded each time Web::Action will be included
      # This is useful for share common functionalities
      #
      # See: http://www.rubydoc.info/gems/lotus-controller#Configuration
      controller.prepare do
        # include MyAuthentication # included in all the actions
        # before :authenticate!    # run an authentication before callback
      end

      # Configure the code to be yielded each time Web::View will be included
      # This is useful for share common functionalities
      #
      # See: http://www.rubydoc.info/gems/lotus-view#Configuration
      view.prepare do
        include Lotus::Helpers
      end
    end

    ##
    # DEVELOPMENT
    #
    configure :development do
      # Don't handle exceptions, render the stack trace
      handle_exceptions false

      # Serve static assets during development
      serve_assets      true
    end

    ##
    # TEST
    #
    configure :test do
      # Don't handle exceptions, render the stack trace
      handle_exceptions false

      # Serve static assets during development
      serve_assets      true
    end

    ##
    # PRODUCTION
    #
    configure :production do
      # scheme 'https'
      # host   'example.org'
      # port   443
      serve_assets      true
    end

    Slim::Engine.set_options pretty: true
  end
end
