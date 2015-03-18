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
   query = BASE_QUERY + "&METHOD=" + "SetExpressCheckout"+
                "&RETURNURL=" + returnUrl + "&CANCELURL=" + cancelUrl +
                "&PAYMENTREQUEST_0_AMT=" + amount.to_s +
                "&PAYMENTREQUEST_0_PAYMENTACTION=" + "Sale"

   res_hash = callApi(query)

   return LOGIN_URL + res_hash["TOKEN"]

  end

  def self.getEC(token)
    query = BASE_QUERY + "&METHOD=" + "GetExpressCheckoutDetails" +
      "&TOKEN=" + token

    resh_hash = callApi(query)

    return resh_hash

  end

  def self.doEC(token, payer_id, amount)
    query = BASE_QUERY + "&METHOD=" + "DoExpressCheckoutPayment"+
      "&TOKEN=" + token + "&PAYERID=" + payer_id +
      "&PAYMENTREQUEST_0_AMT=" + amount.to_s +
      "&PAYMENTREQUEST_0_PAYMENTACTION=" + "Sale"

    resh_hash = callApi(query)

    return resh_hash

  end

  private
  def self.callApi(query)
    uri = URI.parse(API_URL)

    https = Net::HTTP.new(uri.host, 443)

    https.use_ssl = true

    #If you encounter SSL error, toggle this line.
    #https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    q = URI.escape(query)

    p "callApi query: #{q}"

    res = https.post(uri.path, q)

    p "callApi response: #{res.body}"

    res_hash = Hash[URI::decode_www_form(res.body)]

    return res_hash

  end

end
