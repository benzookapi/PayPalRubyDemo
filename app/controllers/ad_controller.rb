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

    @p_call="AdaptiveAccounts/CreateAccount"

@q_call=<<"Q_CALL"
accountType=Business&
emailAddress=benzookapi+B#{Random.rand(100 .. 500).to_s}@gmail.com&
name.firstName=Benzo&
name.lastName=Okapi&
dateOfBirth=1999-01-01Z&
address.line1=aaaa&
address.line2=bbbb&
address.city=Shibuya-ku&
address.state=Tokyo&
address.postalCode=1070061&
address.countryCode=JP&
contactPhoneNumber=03-1234-5678&
currencyCode=JPY&
citizenshipCountryCode=JP&
preferredLanguageCode=ja_JP&
businessInfo.businessAddress.line1=aaaa&
businessInfo.businessAddress.line2=bbbb&
businessInfo.businessAddress.city=Shibuya-ku&
businessInfo.businessAddress.state=Tokyo&
businessInfo.businessAddress.postalCode=1070061&
businessInfo.businessAddress.countryCode=JP&
businessInfo.businessName=BO Corp&
businessInfo.workPhone=03-1234-5678&
businessInfo.merchantCategoryCode=0763&
businessInfo.businessType=INDIVIDUAL&
businessInfo.customerServiceEmail=benzookapi-B@gmail.com&
notificationURL=https://jo-pp-ruby-demo.herokuapp.com/ipn&
registrationType=Web&
createAccountWebOptions.returnUrl=https://jo-pp-ruby-demo.herokuapp.com/ad
Q_CALL

  end

  def call
      @p_call = params[:p_call]
      @q_call = params[:q_call]

      path = @p_call.split('/')

      res = PpAdaptive.call_api(@q_call, path[0], path[1])

      p "==================call: #{res}"

      @res = res

      render template: 'ad/index'
  end

  def pay
    session[:q_pay] = params[:q_pay]
    session[:q_setpo] = params[:q_setpo]

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/ad'

    res = PpAdaptive.pay(callback + '?st=redirect', callback + '?st=cancel', session[:q_pay])

    p "==================pay: #{res}"

    if res['payKey'].present? && session[:q_setpo].present? then
      p "==================setpo: #{PpAdaptive.set_po(res['payKey'], session[:q_setpo])}"
    end

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
