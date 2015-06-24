class AdController < ApplicationController

  def index
    if params.has_key?(:st) then
      p "==================index redirected: #{Time.now}"
      @res = session[:res]
      @q_paydt = "payKey=" + @res['payKey'] if @res['payKey'].present?
    elsif params.has_key?(:st_preapp) then
      p "==================index redirected: #{Time.now}"
      @res_preapp = session[:res_preapp]
    else
      init_amt = Random.rand(100 .. 500).to_s
      session[:q_pay] = "actionType=PAY&currencyCode=USD" +
      "\r\n&receiverList.receiver(0).amount=#{init_amt}\r\n&receiverList.receiver(0).email=WHO_YOU_WANT_PAY"
      session[:q_preapp] = "currencyCode=USD"
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

  def execpay
    @k_execpay = params[:k_execpay]
    @q_execpay = params[:q_execpay]

    @res = PpAdaptive.exec_pay(@k_execpay, @q_execpay)

    p "==================execpay: #{@res}"

    render template: 'ad/index'
  end

  def paydt
    @q_paydt = params[:q_paydt]

    @res = PpAdaptive.pay_dt(@q_paydt)

    p "==================paydt: #{@res}"

    render template: 'ad/index'
  end

  def refund
    @q_refund = params[:q_refund]

    @res = PpAdaptive.refund(@q_refund)

    p "==================refund: #{@res}"

    render template: 'ad/index'
  end

  def preapp
    session[:q_preapp] = params[:q_preapp]

    @sd_preapp = params[:sd_preapp]
    @ed_preapp = params[:ed_preapp]

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/ad'

    res = PpAdaptive.pre_app(callback + '?st_preapp=redirect', callback + '?st_preapp=cancel',
      @sd_preapp, @ed_preapp, session[:q_preapp])

    p "==================preapp: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      session[:res_preapp] = res
      redirect_to(res['_MY_REDIRECT'])
    else
      @res_preapp = res
      render template: 'ad/index'
    end
  end
end
