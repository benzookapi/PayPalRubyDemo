class ClController < ApplicationController

  def index
    if params.has_key?(:token) then
      @t_getec = params[:token]
      @t_doec = @t_getec
      @p_doec = params[:PayerID]
    else
      @endpoint = PpClassic::ENDPOINT_NVP_SIG
      @q_setec = 'PAYMENTREQUEST_0_AMT=100&PAYMENTREQUEST_0_PAYMENTACTION=Sale'
      @q_doec = 'PAYMENTREQUEST_0_AMT=100&PAYMENTREQUEST_0_PAYMENTACTION=Sale'
      @t_getec = ''
      @t_doec = ''
      @p_doec = ''
    end
  end

  def setec
    @endpoint = params[:endpoint]
    @q_setec = params[:q_setec]

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/cl'

    res = PpClassic.set_ec(callback, callback, @q_setec, @endpoint)

    p "==================setec: #{res}"

    if res.start_with?('http') then
      @success = true
      redirect_to(res)
    else
      @success = false
      @method = 'SetExpressCheckout'
      @res = res
      render template: 'cl/index'
    end
  end

  def getec
    @t_getec = params[:t_getec]

    res = PpClassic.get_ec(@t_getec, @endpoint)

    p "==================getec #{res}"

    @method = 'GetExpressCheckoutDetails'
    @res = res.to_s

    if res['ACK'] == 'Success' then
      @success = true
    else
      @success = false
    end

    render template: 'cl/index'
  end

  def doec
    @t_doec = params[:t_doec]
    @p_doec = params[:p_doec]
    @q_doec = params[:q_doec]

    res = PpClassic.do_ec(@t_doec, @p_doec, @q_doec, @endpoint)

    p "==================doec #{res}"

    @method = 'DoExpressCheckoutPayment'
    @res = res.to_s

    if res['ACK'] == 'Success' then
      @success = true
    else
      @success = false
    end

    render template: 'cl/index'
  end
end
