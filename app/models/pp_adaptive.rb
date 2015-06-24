require 'uri'
require 'net/http'

# PayPal Adaptive API wrapper
class PpAdaptive
  IS_PROD = ENV.has_key?('PP_PROD') && ENV['PP_PROD'] == 'true' ? true : false

  private
  def self.set_variable(variable)
    IS_PROD ? variable.sub('sandbox.', '') : variable
  end

  API_PATH_ACCOUNT = 'AdaptiveAccounts'

  API_PATH_PAYMENT = 'AdaptivePayments'

  API_PATH_INVOICE = 'Invoice'

  API_PATH_PERMISSION = 'Permissions'

  API_URL_AD = set_variable(PayPalRubyDemo::Application.config.paypal_api_url_ad)

  API_USER = ENV['PP_API_USER']

  API_PWD = ENV['PP_API_PWD']

  API_SIG = ENV['PP_API_SIG']

  API_APP_AD = ENV['PP_API_APP_AD']

  CMD_URL = set_variable(PayPalRubyDemo::Application.config.paypal_cmd_url)

  QUERY_PRFX = 'requestEnvelope.errorLanguage=en_US&'

  def self.pay(returnUrl, cancelUrl, query)
    q = QUERY_PRFX + 'returnUrl=' + returnUrl + '&cancelUrl=' + cancelUrl + '&' + query

    res = call_api(q, API_PATH_PAYMENT, 'Pay')

    if res.has_key?('payKey') then
      res['_MY_REDIRECT'] = CMD_URL + '_ap-payment&paykey=' + res['payKey']
    end

    res
  end

  def self.exec_pay(key, query)
    q = QUERY_PRFX + 'payKey=' + key + '&' + query
    call_api(q, API_PATH_PAYMENT, 'ExecutePayment')
  end

  def self.pay_dt(query)
    call_api(QUERY_PRFX + query, API_PATH_PAYMENT, 'PaymentDetails')
  end

    def self.refund(query)
      call_api(QUERY_PRFX + query, API_PATH_PAYMENT, 'Refund')
    end

  def self.pre_app(returnUrl, cancelUrl, start_date, end_date, query)
    q = QUERY_PRFX + 'returnUrl=' + returnUrl + '&cancelUrl=' + cancelUrl + '&' +
     'startingDate=' + start_date + '&endingDate=' + end_date + '&' + query

    res = call_api(q, API_PATH_PAYMENT, 'Preapproval')

    if res.has_key?('preapprovalKey') then
      res['_MY_REDIRECT'] = CMD_URL + '_ap-preapproval&preapprovalkey=' + res['preapprovalKey']
    end

    res
  end

  private
  def self.call_api(query, path, sub_path)
    api_url = API_URL_AD + path + '/' + sub_path

    uri = URI.parse(api_url)

    p "==================call_api uri: #{uri}"

    q = URI.escape(query.gsub("\r", "").gsub("\n", "")).gsub('+', '%2B')

    p "==================call_api query: #{q}"

    https = Net::HTTP.new(uri.host, 443)

    https.use_ssl = true

    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req = Net::HTTP::Post.new(uri.request_uri)
    req['X-PAYPAL-SECURITY-USERID'] =API_USER
    req['X-PAYPAL-SECURITY-PASSWORD'] = API_PWD
    req['X-PAYPAL-SECURITY-SIGNATURE'] = API_SIG
    req['X-PAYPAL-APPLICATION-ID'] = API_APP_AD
    req['X-PAYPAL-REQUEST-DATA-FORMAT'] = 'NV' # or 'JSON'
    req['X-PAYPAL-RESPONSE-DATA-FORMAT'] = 'NV' # or 'JSON'
    # req['X-PAYPAL-DEVICE-IPADDRESS'] = '127.0.0.1'
    # req['X-PAYPAL-REQUEST-SOURCE'] = 'merchant-php-sdk-2.0.96'
    # req['X-PAYPAL-SANDBOX-EMAIL-ADDRESS'] = 'Platform.sdk.seller@gmail.com'
    req.body = q

    https.set_debug_output $stderr

    now = Time.now

    res = https.request(req)

    elapsed = Time.now - now

    p "==================call_api elapsed time (sec.): #{elapsed}"
    p "==================call_api response code: #{res.code}"
    p "==================call_api response msg: #{res.message}"
    p "==================call_api response body: #{res.body}"

    res = Hash[URI.decode_www_form(res.body)]

    res['_MY_ELAPSED_TIME'] = elapsed

    res
  end



end
