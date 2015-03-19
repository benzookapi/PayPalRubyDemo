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

 def self.set_ec(returnUrl, cancelUrl, query)
   q = BASE_QUERY + "&METHOD=" + "SetExpressCheckout"+
                "&RETURNURL=" + returnUrl + "&CANCELURL=" + cancelUrl +
                "&" + query

   res_hash = call_api(q)

   return LOGIN_URL + res_hash["TOKEN"]

  end

  def self.get_ec(token)
    q = BASE_QUERY + "&METHOD=" + "GetExpressCheckoutDetails" +
      "&TOKEN=" + token

    resh_hash = call_api(q)

    return resh_hash

  end

  def self.do_ec(token, payer_id, query)
    q = BASE_QUERY + "&METHOD=" + "DoExpressCheckoutPayment"+
      "&TOKEN=" + token + "&PAYERID=" + payer_id +
      "&" + query

    resh_hash = call_api(q)

    return resh_hash

  end

  private
  def self.call_api(query)
    uri = URI.parse(API_URL)

    https = Net::HTTP.new(uri.host, 443)

    https.use_ssl = true

    #If you encounter SSL error, toggle this line.
    #https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    q = URI.escape(query)

    p "==================call_api query: #{q}"

    res = https.post(uri.path, q)

    p "==================call_api response: #{res.body}"

    res_hash = Hash[URI::decode_www_form(res.body)]

    return res_hash

  end

end
