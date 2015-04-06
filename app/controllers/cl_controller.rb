class ClController < ApplicationController

  def index
    if params.has_key?(:st) then
      p "==================index redirected: #{Time.now}"
    end
    if params.has_key?(:token) then
      @t_getec = params[:token]
      @t_doec = @t_getec
      @t_crrp = @t_getec
      @p_doec = params[:PayerID]
      @method = 'SetExpressCheckout'
      @res = session[:res]
    else
      init_amt = Random.rand(100 .. 500).to_s
      session[:endpoint] = PpClassic::ENDPOINT_NVP_CER
      session[:q_setec] = 'PAYMENTREQUEST_0_AMT=' + init_amt + '&L_BILLINGTYPE0=RecurringPayments' +
      '&L_BILLINGAGREEMENTDESCRIPTION0=MY_RECURRSIVE_PAYMENT_' + init_amt
      session[:res] = nil
      session[:ua] = request.user_agent
    end
    amt = session[:q_setec].match(/PAYMENTREQUEST_0_AMT=(\d{1,9})/)[1]
    @q_doec = 'PAYMENTREQUEST_0_AMT=' + amt
    desc = session[:q_setec].match(/L_BILLINGAGREEMENTDESCRIPTION0=([^&]+)/)[1]
    session[:q_crrp] = 'AMT=' + amt + '&BILLINGPERIOD=Day&BILLINGFREQUENCY=1&DESC=' + desc
  end

  def setec
    session[:endpoint] = params[:endpoint]
    session[:q_setec] = params[:q_setec]

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/cl'

    res = PpClassic.set_EC(callback + '?st=redirect', callback + '?st=cancel', session[:q_setec], session[:endpoint])

    p "==================setec: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      session[:res] = res
      redirect_to(res['_MY_REDIRECT'])
    else
      @method = 'SetExpressCheckout'
      @res = res
      render template: 'cl/index'
    end
  end

  def getec
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @t_crrp = params[:t_crrp]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    res = PpClassic.get_EC(@t_getec, session[:endpoint])

    p "==================getec #{res}"

    @method = 'GetExpressCheckoutDetails'
    @res = res

    render template: 'cl/index'
  end

  def doec
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @t_crrp = params[:t_crrp]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    res = PpClassic.do_EC(@t_doec, @p_doec, @q_doec, session[:endpoint])

    p "==================doec #{res}"

    @method = 'DoExpressCheckoutPayment'
    @res = res

    render template: 'cl/index'
  end

  def crrp
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @t_crrp = params[:t_crrp]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    @sd_crrp = params[:sd_crrp]
    session[:q_crrp] = params[:q_crrp]

    res = PpClassic.create_RP(@t_crrp, @sd_crrp, session[:q_crrp], session[:endpoint])

    p "==================crrp #{res}"

    @method = 'CreateRecurringPaymentsProfile'
    @res = res

    render template: 'cl/index'
  end

  def trsr
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @t_crrp = params[:t_crrp]

    @sd_trsr = params[:sd_trsr]
    @q_trsr = params[:q_trsr]

    res = PpClassic.search_TR(@sd_trsr, @q_trsr, session[:endpoint])

    p "==================trsr #{res}"

    @method = 'TransactionSearch'
    @res = res

    render template: 'cl/index'
  end
end
