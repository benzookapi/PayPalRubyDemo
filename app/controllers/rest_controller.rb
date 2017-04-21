require 'paypal-sdk-rest'
include PayPal::SDK::REST

class RestController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    if params.has_key?(:token) then

    else
      session[:res_rest] = nil
    end

    res = PpRest.get_token()

    p "==================index: #{res}"

    session[:token] = res['access_token']

    p "==================index access_token: #{session[:token]}"

    @u_call = "https://api.sandbox.paypal.com/v1/payments/payment"

@q_call=<<"Q_COMM"
{
    "intent": "sale",
    "payer": {
      "payment_method": "credit_card",
      "funding_instruments": [
        {
          "credit_card": {
            "number": "4148529247832259",
            "type": "visa",
            "expire_month": 12,
            "expire_year": 2018,
            "cvv2": 111,
            "first_name": "Betsy",
            "last_name": "Buyer"
          }
        }
      ]
    },
    "transactions": [
      {
        "amount": {
          "total": "7.47",
          "currency": "USD"
        },
        "description": "This is the payment transaction description."
      }
    ]
  }
Q_COMM

@q_pay=<<"Q_PAY"
{
  "intent":"sale",
  "payer":{
    "payment_method":"paypal"
  },
  "redirect_urls": {
        "return_url": "#{PpRest::API_APP_REST_URI}",
        "cancel_url":"#{PpRest::API_APP_REST_URI}"
    },
  "transactions":[
    {
      "amount":{
        "total":"200",
        "currency":"JPY"
      },
      "description":"This is the payment transaction description."
    }
  ]
}
Q_PAY

@q_payouts=<<"Q_PAYOUTS"
{
    "sender_batch_header": {
        "sender_batch_id": "2014021801",
        "email_subject": "You have a Payout!",
        "recipient_type": "EMAIL"
    },
    "items": [
        {
            "recipient_type": "EMAIL",
            "amount": {
                "value": "1.0",
                "currency": "USD"
            },
            "note": "Thanks for your patronage!",
            "sender_item_id": "201403140001",
            "receiver": "WHO_YOU_WANT_PAY"
        }
    ]
}
Q_PAYOUTS

    @i_dopay = params['paymentId']

@q_dopay=<<"Q_DOPAY"
{ "payer_id" : "#{params['PayerID']}" }
Q_DOPAY

  end

  def call
    @u_call = params[:u_call]
    @m_call = params[:m_call]
    @q_call = params[:q_call]
    @h_call = params[:h_call]

    @res = PpRest.call_api(@q_call, @u_call.gsub("#{PpRest::API_URL_REST}", ""), '', session[:token], @m_call, false, @h_call)

    p "==================call: #{@res}"

    render template: 'rest/index'

  end
  def pay
    @q_pay = params[:q_pay]

    res = PpRest.pay(@q_pay, session[:token])

    session[:res_rest] = res

    p "==================pay: #{res}"

    redirect = ''
    res['links'].each do |l|
      if l['method'] == 'REDIRECT' then
        redirect = l['href'] + '&useraction=commit'
      end
    end

    if redirect.empty? then
      render template: 'rest/index'
    else
      redirect_to redirect
    end
  end

  def dopay
    @i_dopay = params[:i_dopay]
    @q_dopay = params[:q_dopay]

    @res = PpRest.do_pay(@q_dopay, @i_dopay, session[:token])

    p "==================dopay: #{@res}"

    render template: 'rest/index'

  end

  def getpay
    @i_getpay = params[:i_getpay]

    @res = PpRest.get_pay(@i_getpay, session[:token])

    p "==================getpay: #{@res}"

    render template: 'rest/index'
  end

  def payouts
    @q_payouts = params[:q_payouts]

    @res = PpRest.payout(@q_payouts, session[:token])

    p "==================payouts: #{@res}"

    render template: 'rest/index'
  end

  def token
    res = PpRest.get_token(true)
    p "==================token: #{res}"
    token = res['access_token']
    render :text => "#{token}"
  end

  def cors
    res = PpRest.get_token(true)
    p "==================cors: #{res}"
    @token = res['access_token']
    render template: 'rest/cors'
  end

  def invoice
    res = PpRest.get_token(true)
    p "==================invoice: #{res}"
    @token = res['access_token']
    render template: 'rest/invoice'
  end

  def ecqr
    res = PpRest.get_token(true)
    p "==================ecqr: #{res}"
    @token = res['access_token']
    @msg = ""
    if params.has_key?(:paymentId) then
      payId = params[:paymentId]
      payer_id = params[:PayerID]
      t = params[:token]
      res = PpRest.do_pay("{ \"payer_id\" : \"#{payer_id}\" }", payId, t)
      p "==================ecqr: #{res}"
      @msg = "<h2>Thank you! Your payment has been accepted!</h2>"
    end
    render template: 'rest/ecqr'
  end

  def call_qr
    require 'net/http'
    uri = URI.parse("http://api.qrserver.com/v1/create-qr-code?data=" + ERB::Util.url_encode(params[:url]))
    res = Net::HTTP.get_response(uri)
    p "==================call_qr: #{res.body}"
    imgSrc = res.body.match(/href="(.+?)"/)
    render :text => "#{imgSrc[1]}"
  end

  def fp
    desc = params[:desc]
    p "==================fp: desc:#{desc}"
    render :text => "#{desc}"
  end

end
