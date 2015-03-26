class ClController < ApplicationController

  def index
    if params.has_key?(:token) then
      p "==================index redirected: #{Time.now}"
      @t_getec = params[:token]
      @t_doec = @t_getec
      @p_doec = params[:PayerID]
      @method = 'SetExpressCheckout'
      @res = session[:res]
    else
      session[:endpoint] = PpClassic::ENDPOINT_NVP_SIG
      session[:q_setec] = 'PAYMENTREQUEST_0_AMT=100&PAYMENTREQUEST_0_PAYMENTACTION=Sale'
      session[:res] = nil
    end
    @q_doec = session[:q_setec]
  end

  def setec
    session[:endpoint] = params[:endpoint]
    session[:q_setec] = params[:q_setec]

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/cl'

    res = PpClassic.set_ec(callback + '?st=redirect', callback + '?st=cancel', session[:q_setec], @endpoint)

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
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    res = PpClassic.get_ec(@t_getec, @endpoint)

    p "==================getec #{res}"

    @method = 'GetExpressCheckoutDetails'
    @res = res

    render template: 'cl/index'
  end

  def doec
    @t_getec = params[:t_getec]
    @t_doec = params[:t_doec]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    res = PpClassic.do_ec(@t_doec, @p_doec, @q_doec, @endpoint)

    p "==================doec #{res}"

    @method = 'DoExpressCheckoutPayment'
    @res = res

    render template: 'cl/index'
  end
end