class ClController < ApplicationController

  def index
    if params.has_key?(:st) then
      p "==================index redirected: #{Time.now}"
    end
    if params.has_key?(:token) then
      @t_getec = params[:token]
      @t_doec = @t_getec
      @t_crrp = @t_getec
      @t_crba = @t_getec
      @p_doec = params[:PayerID]
      @res = session[:res]
    else
      init_amt = Random.rand(100 .. 500).to_s
      session[:endpoint] = PpClassic::ENDPOINT_NVP_SIG
      session[:q_setec] = 'PAYMENTREQUEST_0_AMT=' + init_amt + '&L_BILLINGTYPE0=RecurringPayments' +
      '&L_BILLINGAGREEMENTDESCRIPTION0=MY_RECURRSIVE_PAYMENT_' + init_amt
      session[:res] = nil
      session[:ua] = request.user_agent
      session[:is_us] = params[:is_us]
    end
    a = session[:q_setec].match(/PAYMENTREQUEST_0_AMT=(\d{1,9})/)
    amt = a.blank? ? '0' : a[1]
    @q_doec = 'PAYMENTREQUEST_0_AMT=' + amt
    d = session[:q_setec].match(/L_BILLINGAGREEMENTDESCRIPTION0=([^&]+)/)
    desc = d.blank? ? '' : d[1]
    session[:q_crrp] = 'AMT=' + amt + '&BILLINGPERIOD=Day&BILLINGFREQUENCY=1&DESC=' + desc
  end

  def setec
    session[:endpoint] = params[:endpoint]
    session[:q_setec] = params[:q_setec]

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/cl'

    res = PpClassic.set_EC(callback + '?st=redirect', callback + '?st=cancel', session[:q_setec], session[:endpoint],
      false, false, set_is_us(params, session))

    p "==================setec: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      session[:res] = res
      redirect_to(res['_MY_REDIRECT'])
    else
      @res = res
      render template: 'cl/index'
    end
  end

  def getec
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @t_crrp = params[:t_crrp]
    @t_crba = params[:t_crba]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    res = PpClassic.get_EC(@t_getec, session[:endpoint], set_is_us(params, session))

    p "==================getec #{res}"

    @res = res

    render template: 'cl/index'
  end

  def doec
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @t_crrp = params[:t_crrp]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    res = PpClassic.do_EC(@t_doec, @p_doec, @q_doec, session[:endpoint], set_is_us(params, session))

    p "==================doec #{res}"

    @res = res

    render template: 'cl/index'
  end

  def crrp
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    @t_crrp = params[:t_crrp]
    @sd_crrp = params[:sd_crrp]
    session[:q_crrp] = params[:q_crrp]

    res = PpClassic.create_RP(@t_crrp, @sd_crrp, session[:q_crrp], session[:endpoint], set_is_us(params, session))

    p "==================crrp #{res}"

    @res = res

    render template: 'cl/index'
  end

  def crba
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    @t_crba = params[:t_crba]

    res = PpClassic.create_BA(@t_crba, session[:endpoint], set_is_us(params, session))

    p "==================crba #{res}"

    @res = res

    render template: 'cl/index'
  end

  def trsr
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]

    @sd_trsr = params[:sd_trsr]
    @q_trsr = params[:q_trsr]

    res = PpClassic.search_TR(@sd_trsr, @q_trsr, session[:endpoint], set_is_us(params, session))

    p "==================trsr #{res}"

    @res = res

    render template: 'cl/index'
  end

  def gettr
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]

    @i_gettr = params[:i_gettr]
    @q_gettr = params[:q_gettr]

    res = PpClassic.get_TR(@i_gettr, @q_gettr, session[:endpoint], set_is_us(params, session))

    p "==================gettr #{res}"

    @res = res

    render template: 'cl/index'
  end

  def getrp
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]

    @i_getrp = params[:i_getrp]
    @q_getrp = params[:q_getrp]

    res = PpClassic.get_RP(@i_getrp, @q_getrp, session[:endpoint], set_is_us(params, session))

    p "==================getrp #{res}"

    @res = res

    render template: 'cl/index'
  end

  def dort
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]

    @i_dort = params[:i_dort]
    @q_dort = params[:q_dort]

    res = PpClassic.do_RT(@i_dort, @q_dort, session[:endpoint], set_is_us(params, session))

    p "==================dort #{res}"

    @res = res

    render template: 'cl/index'
  end
end
