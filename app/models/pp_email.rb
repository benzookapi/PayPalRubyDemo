require 'uri'
require 'net/http'
require 'json'

class PpEmail

  SENDGRID_API_URL = PayPalRubyDemo::Application.config.sendgrid_api_url

  SENDGRID_KEY = ENV['SENDGRID_KEY']

  def self.send_QR(to, from, subject, html)
    query = "to=#{to}&from=#{from}&subject=#{subject}&html=#{html}"
    call_api(query, "mail.send.json")
  end

  private
  def self.call_api(query, path, token = SENDGRID_KEY, get = false)
    api_url = SENDGRID_API_URL + path

    uri = URI.parse(api_url)

    p "==================call_api uri: #{uri}"

    p "==================call_api query: #{query}"

    https = Net::HTTP.new(uri.host, 443)

    https.use_ssl = true

    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    req = Net::HTTP::Post.new(uri.request_uri)
    if get then
      req = Net::HTTP::Get.new(uri.request_uri)
    end

    #req['Content-Type'] ='application/json'
    req['Authorization'] = "Bearer #{token}"

    req.body = query

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
