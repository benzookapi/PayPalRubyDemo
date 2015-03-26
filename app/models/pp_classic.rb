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

  CMD_URL = PayPalRubyDemo::Application.config.paypal_cmd_url

  BASE_QUERY = 'USER=' + API_USER + '&PWD=' + API_PWD +
    '&SIGNATURE=' + API_SIG + '&VERSION=' + API_VERSION

  def self.set_ec(returnUrl, cancelUrl, query, endpoint = ENDPOINT_NVP_SIG)
    q = BASE_QUERY + '&METHOD=' + 'SetExpressCheckout' +
      '&RETURNURL=' + returnUrl + '&CANCELURL=' + cancelUrl + '&' + query

    res = call_api(q, endpoint)

    if res.has_key?('TOKEN') then
      res['_MY_REDIRECT'] = CMD_URL + '_express-checkout&token=' + res['TOKEN']
    end

    res
  end

  def self.get_ec(token, endpoint = ENDPOINT_NVP_SIG)
    q = BASE_QUERY + '&METHOD=' + 'GetExpressCheckoutDetails' +
      '&TOKEN=' + token

    call_api(q, endpoint)
  end

  def self.do_ec(token, payer_id, query, endpoint = ENDPOINT_NVP_SIG)
    q = BASE_QUERY + '&METHOD=' + 'DoExpressCheckoutPayment' +
      '&TOKEN=' + token + '&PAYERID=' + payer_id +
      '&' + query

    call_api(q, endpoint)
  end

  private
  def self.call_api(query, endpoint)
    api_url = API_URL_NVP_SIG
    case endpoint
    when ENDPOINT_NVP_SIG then
      api_url = API_URL_NVP_SIG
    when ENDPOINT_NVP_CER then
      api_url = API_URL_NVP_CER
    when ENDPOINT_NVP_CER_CDN then
      api_url = API_URL_NVP_CER_CDN
    end

    uri = URI.parse(api_url)

    p "==================call_api uri: #{uri}"

    https = Net::HTTP.new(uri.host, 443)

    https.use_ssl = true

    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    # If you want to skip certificate validation, toggle this line.
    # https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    q = URI.escape(query)

    p "==================call_api query: #{q}"

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