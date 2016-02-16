require File.expand_path('../boot', __FILE__)

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"
Bundler.require(*Rails.groups)

module MetalArchivesRestApi
  class Application < Rails::Application
    config.action_dispatch.default_headers = {
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(","),
        'Access-Control-Allow-Headers' => %w{content-type, accept}
    }
  end
end
