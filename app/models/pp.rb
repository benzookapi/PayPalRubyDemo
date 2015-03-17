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

 def setEC(returnUrl, cancelUrl, amount)
     query = URI.escape(BASE_QUERY + "&METHOD=" + "SetExpressCheckout"+
                "&RETURNURL=" + returnUrl + "&CANCELURL=" + cancelUrl +
                "&PAYMENTREQUEST_0_AMT=" + amount.to_s +
                "&PAYMENTREQUEST_0_PAYMENTACTION=" + "Sale")



     uri = URI.parse(API_URL)

     http = Net::HTTP.new(uri.host)

     http.use_ssl = true

     p uri.host

     p query

     p uri.path

     #begin
      res = http.post(uri.path, query)

    # rescue => e
      p "www#{e}"


     #p res

  #   end

   return LOGIN_URL

  end

end
