require 'uri'
require 'net/http'

class Pp < ActiveRecord::Base

  API_URL = PayPalRubyDemo::Application.config.paypal_api_url

  API_VERSION = PayPalRubyDemo::Application.config.paypal_api_version

  API_USER = ENV["PP_API_USER"]

  API_PWD = ENV["PP_API_PWD"]

  API_SIG = ENV["PP_API_SIG"]

  LOGIN_URL = PayPalRubyDemo::Application.config.paypal_login_url

  BASE_QUERY = "USER=" + API_USER + "&PWD=" +
             API_PWD + "&SIGNATURE=" + API_SIG + "&VERSION=" + API_VERSION

 def self.setEC(returnUrl, cancelUrl, amount)
   query = URI.escape(BASE_QUERY + "&METHOD=" + "SetExpressCheckout"+
                "&RETURNURL=" + returnUrl + "&CANCELURL=" + cancelUrl +
                "&PAYMENTREQUEST_0_AMT=" + amount.to_s +
                "&PAYMENTREQUEST_0_PAYMENTACTION=" + "Sale")

   uri = URI.parse(API_URL)

   https = Net::HTTP.new(uri.host, 443)

   https.use_ssl = true
   https.verify_mode = OpenSSL::SSL::VERIFY_NONE

   puts "setEC query: #{query}"

   res = https.post(uri.path, query)

   puts "setEC response: #{res.body}"

   res_hash = Hash[URI::decode_www_form(res.body)]

   return LOGIN_URL + res_hash["TOKEN"]

  end

end
