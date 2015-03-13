class Pp < ActiveRecord::Base

  API_URL = PayPalRubyDemo::Application.config.paypal.api.url

  API_VERSION = PayPalRubyDemo::Application.config.paypal.api.version

  API_USER = System.getenv("PP_API_USER");

  API_PWD = System.getenv("PP_API_PWD");

  API_SIG = System.getenv("PP_API_SIG");

  LOGIN_URL = PayPalRubyDemo::Application.config.paypal.login.url

  BASE_QUERY = "USER=" + API_USER + "&PWD="
            + API_PWD + "&SIGNATURE=" + API_SIG + "&VERSION=" + API_VERSION

  
end
