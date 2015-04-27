class AdController < ApplicationController

  def index
    if params.has_key?(:st) then
      p "==================index redirected: #{Time.now}"
      @res = session[:res]
    else
      init_amt = Random.rand(100 .. 500).to_s
      session[:q_pay] = "actionType=PAY&currencyCode=USD&requestEnvelope.errorLanguage=en_US&" +
      "receiverList.receiver(0).amount=#{init_amt}&receiverList.receiver(0).email=WHO_YOU_WANT_PAY"
    end
  end

  def pay
    session[:q_pay] = params[:q_pay]

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/ad'

    res = PpAdaptive.pay(callback + '?st=redirect', callback + '?st=cancel', session[:q_pay])

    p "==================pay: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      session[:res] = res
      redirect_to(res['_MY_REDIRECT'])
    else
      @res = res
      render template: 'ad/index'
    end
  end
end
