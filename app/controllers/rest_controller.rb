class RestController < ApplicationController

  def index
    res = PpRest.get_token()

    p "==================index: #{res}"

    session[:token] = res['access_token']

    p "==================index access_token: #{session[:token]}"

@q_pay=<<'Q_PAY'
{
  "intent":"sale",
  "payer":{
    "payment_method":"credit_card",
    "funding_instruments":[
      {
        "credit_card":{
          "number":"4525915739179072",
          "type":"visa",
          "expire_month":11,
          "expire_year":2019,
          "cvv2":"123",
          "first_name":"Benzo",
          "last_name":"Okapi",
          "billing_address":{
            "line1":"111 First Street",
            "city":"Minato-ku",
            "state":"Tokyo",
            "postal_code":"12345678",
            "country_code":"JP"
          }
        }
      }
    ]
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

  end

  def pay
    @q_pay = params[:q_pay]

    res = PpRest.pay(@q_pay, session[:token])

    p "==================pay: #{res}"

    @res = res
    render template: 'rest/index'
  end

  def getpay
    @i_getpay = params[:i_getpay]

    res = PpRest.get_pay(@i_getpay, session[:token])

    p "==================getpay: #{res}"

    @res = res
    render template: 'rest/index'
  end
end
