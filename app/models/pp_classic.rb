require 'uri'
require 'net/http'

# PP
class PpClassic
  ENDPOINT_NVP_SIG = 'sig'

  ENDPOINT_NVP_CER = 'cer'

  ENDPOINT_NVP_CER_CDN = 'cer_cdn'

  API_URL_NVP_SIG = PayPalRubyDemo::Application.config.paypal_api_url_nvp_sig

  API_URL_NVP_CER = PayPalRubyDemo::Application.config.paypal_api_url_nvp_cer

  API_URL_NVP_CER_CDN = PayPalRubyDemo::Application.config.paypal_api_url_nvp_cer_cdn

  API_VERSION = PayPalRubyDemo::Application.config.paypal_api_version

  API_USER = ENV['PP_API_USER']

  API_PWD = ENV['PP_API_PWD']

  API_SIG = ENV['PP_API_SIG']

  API_USER_CER = ENV['PP_API_USER_CER']

  API_PWD_CER = ENV['PP_API_PWD_CER']

  CMD_URL = PayPalRubyDemo::Application.config.paypal_cmd_url

  def self.set_ec(returnUrl, cancelUrl, query, endpoint = ENDPOINT_NVP_SIG)
    q = '&METHOD=' + 'SetExpressCheckout' +
      '&RETURNURL=' + returnUrl + '&CANCELURL=' + cancelUrl + '&' + query

    res = call_api(q, endpoint)

    if res.has_key?('TOKEN') then
      res['_MY_REDIRECT'] = CMD_URL + '_express-checkout&token=' + res['TOKEN']
    end

    res
  end

  def self.get_ec(token, endpoint = ENDPOINT_NVP_SIG)
    q = '&METHOD=' + 'GetExpressCheckoutDetails' +
      '&TOKEN=' + token

    call_api(q, endpoint)
  end

  def self.do_ec(token, payer_id, query, endpoint = ENDPOINT_NVP_SIG)
    q = '&METHOD=' + 'DoExpressCheckoutPayment' +
      '&TOKEN=' + token + '&PAYERID=' + payer_id +
      '&' + query

    call_api(q, endpoint)
  end

  private
  def self.call_api(query, endpoint)
    api_url = API_URL_NVP_SIG

    api_user = API_USER_CER
    api_pwd = API_PWD_CER
    api_sig = ''

    case endpoint
    when ENDPOINT_NVP_SIG then
      api_url = API_URL_NVP_SIG
      api_user = API_USER
      api_pwd = API_PWD
      api_sig = '&SIGNATURE=' + API_SIG
    when ENDPOINT_NVP_CER then
      api_url = API_URL_NVP_CER
    when ENDPOINT_NVP_CER_CDN then
      api_url = API_URL_NVP_CER_CDN
    end

    api_query = 'USER=' + api_user + '&PWD=' + api_pwd + '&VERSION=' + API_VERSION + api_sig + query

    uri = URI.parse(api_url)

    p "==================call_api uri: #{uri}"

    q = URI.escape(api_query)

    p "==================call_api query: #{q}"

    https = Net::HTTP.new(uri.host, 443)

    https.use_ssl = true

    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    # If you want to skip certificate validation, toggle this line.
    # https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    now = Time.now

    res = https.post(uri.path, q)

    elapsed = Time.now - now

    p "==================call_api elapsed time (sec.): #{elapsed}"
    p "==================call_api response: #{res.body}"

    res = Hash[URI.decode_www_form(res.body)]

    res['_MY_ELAPSED_TIME'] = elapsed

    res
  end

end
