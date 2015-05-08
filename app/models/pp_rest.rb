require 'uri'
require 'net/http'
require 'json'

# PayPal REST API wrapper
class PpRest
  IS_PROD = ENV.has_key?('PP_PROD') && ENV['PP_PROD'] == 'true' ? true : false

  private
  def self.set_variable(variable)
    IS_PROD ? variable.sub('sandbox.', '') : variable
  end

  API_URL_REST = set_variable(PayPalRubyDemo::Application.config.paypal_api_url_rest)

  API_PATH_TOKEN = 'oauth2/token'

  API_PATH_PAY = 'payments/payment'

  API_APP_REST = ENV['PP_API_APP_REST']

  API_APP_REST_SEC = ENV['PP_API_APP_REST_SEC']


  def self.get_token()
    call_api('grant_type=client_credentials', API_PATH_TOKEN, '', '')
  end

  def self.pay(query, token)
    call_api(query, API_PATH_PAY, '', token)
  end

  private
  def self.call_api(query, path, sub_path, token)
    api_url = API_URL_REST + path + '/' + sub_path

    uri = URI.parse(api_url)

    p "==================call_api uri: #{uri}"

    q = query
    if token.empty? then
      q = URI.escape(query.gsub("\r", "").gsub("\n", "")).gsub('+', '%2B')
    end

    p "==================call_api query: #{q}"

    https = Net::HTTP.new(uri.host, 443)

    https.use_ssl = true

    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req = Net::HTTP::Post.new(uri.request_uri)
    if token.empty? then
      req['Accept'] ='application/json'
      req['Accept-Language'] = 'en_US'
      req.basic_auth API_APP_REST, API_APP_REST_SEC
    else
      req['Content-Type'] ='application/json'
      req['Authorization'] = "Bearer #{token}"
    end


    req.body = q

    https.set_debug_output $stderr

    now = Time.now

    res = https.request(req)

    elapsed = Time.now - now

    p "==================call_api elapsed time (sec.): #{elapsed}"
    p "==================call_api response code: #{res.code}"
    p "==================call_api response msg: #{res.message}"
    p "==================call_api response body: #{res.body}"

    json = JSON.parse(res.body)

    json['_MY_ELAPSED_TIME'] = elapsed

    json
  end



end
