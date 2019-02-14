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

  API_PATH_TOKEN = 'v1/oauth2/token'

  API_PATH_PAY = 'v1/payments/payment'

  API_PATH_PAYOUT = 'v1/payments/payouts'

  API_PATH_IDENTITY = 'v1/identity/openidconnect/tokenservice'

  API_PATH_USERINFO = 'v1/identity/oauth2/userinfo'
  #API_PATH_USERINFO = 'v1/identity/openidconnect/userinfo'
  #API_PATH_USERINFO = 'v1/oauth2/token/userinfo'

  API_APP_REST = ENV['PP_API_APP_REST']

  API_APP_REST_SEC = ENV['PP_API_APP_REST_SEC']

  API_APP_REST_URI = ENV['PP_API_APP_REST_URI']

  def self.get_token(client = false)
    call_api('grant_type=client_credentials', API_PATH_TOKEN, '', '', 'post', client)
  end

  def self.get_token2(code)
    #call_api("grant_type=authorization_code&code=#{code}&response_type=token&redirect_uri=urn:ietf:wg:oauth:2.0:oob", API_PATH_TOKEN, '', '', 'post', false)
    call_api("grant_type=authorization_code&code=#{code}", API_PATH_TOKEN, '', '', 'post', false)
  end

  def self.pay(query, token)
    call_api(query, API_PATH_PAY, '', token, 'post')
  end

  def self.do_pay(query, id, token)
    call_api(query, API_PATH_PAY, "#{id}/execute", token, 'post')
  end

  def self.get_pay(id, token)
    call_api('', API_PATH_PAY, id, token)
  end

  def self.payout(query, token)
    call_api(query, API_PATH_PAYOUT, '', token, 'post')
  end

  def self.identity(code)
    call_api("grant_type=authorization_code&code=#{code}&redirect_uri=#{API_APP_REST_URI}", API_PATH_IDENTITY, '', '', 'post')
  end

  def self.userinfo(token)
    #call_api('', API_PATH_USERINFO, '?schema=openid', token)
    call_api('', API_PATH_USERINFO, '?schema=paypalv1.1', token)    
  end

  def self.call_api(query, path, sub_path, token, method = 'get', client = false, headers = '')
    api_url = API_URL_REST + path + '/' + sub_path
    if api_url.end_with?('/') then
      api_url = api_url.chop
    end

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

    req = Net::HTTP::Get.new(uri.request_uri)
    case method
    when 'post' then
      req = Net::HTTP::Post.new(uri.request_uri)
    when 'put' then
      req = Net::HTTP::Put.new(uri.request_uri)
    when 'patch' then
      req = Net::HTTP::Patch.new(uri.request_uri)
    when 'delete' then
      req = Net::HTTP::Delete.new(uri.request_uri)
    end

    if token.empty? then
      req['Accept'] ='application/json'
      req['Accept-Language'] = 'en_US'
      if client then
        req.basic_auth API_APP_REST, ''
      else
        req.basic_auth API_APP_REST, API_APP_REST_SEC
      end
    else
      req['Content-Type'] ='application/json'
      req['Authorization'] = "Bearer #{token}"
    end

    if headers.present? then
      headers.split("\n").each do |h|
        i = h.index(":")
        k = h[0, i]
        v = h[i+1, h.length-1]
        req[k] = v.strip
      end
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

    json = JSON.parse(res.body.blank? ? "{}" : res.body)

    json['_MY_ELAPSED_TIME'] = elapsed

    json
  end



end
