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
          "number":"4417119669820331",
          "type":"visa",
          "expire_month":11,
          "expire_year":2018,
          "cvv2":"874",
          "first_name":"Betsy",
          "last_name":"Buyer",
          "billing_address":{
            "line1":"111 First Street",
            "city":"Saratoga",
            "state":"CA",
            "postal_code":"95070",
            "country_code":"US"
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
end
