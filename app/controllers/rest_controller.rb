require 'paypal-sdk-rest'
include PayPal::SDK::REST

class RestController < ApplicationController

  def index
    if params.has_key?(:token) then

    else
      session[:res_rest] = nil
    end

    res = PpRest.get_token()

    p "==================index: #{res}"

    session[:token] = res['access_token']

    p "==================index access_token: #{session[:token]}"

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
        "total":"7.47",
        "currency":"USD",
        "details":{
          "subtotal":"7.41",
          "tax":"0.03",
          "shipping":"0.03"
        }
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

    @res = PpRest.call_api(@q_call, @u_call.gsub("#{PpRest::API_URL_REST}", ""), '', session[:token], @m_call == 'get' ? true : false)

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

  def cors
    render template: 'rest/cors'
  end

end
