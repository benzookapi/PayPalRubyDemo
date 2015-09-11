require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PayPalRubyDemo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.assets.paths << "#{Rails}/vender/assets/fonts"

    config.paypal_api_url_nvp_sig = "https://api-3t.sandbox.paypal.com/nvp"

    config.paypal_api_url_nvp_cer = "https://api.sandbox.paypal.com/nvp"

    config.paypal_api_url_nvp_cer_cdn = "https://api-s.sandbox.paypal.com/nvp"

    config.paypal_api_version = "124.0"

    config.paypal_cmd_url = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=" # _express-checkout&token="

    config.paypal_cmd_url_context = "https://www.sandbox.paypal.com/checkoutnow"

    config.paypal_api_url_ad = "https://svcs.sandbox.paypal.com/"

    config.paypal_api_url_rest = "https://api.sandbox.paypal.com/v1/"

  end
end
