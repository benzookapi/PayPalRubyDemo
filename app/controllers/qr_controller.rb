class QrController < ApplicationController

  protect_from_forgery with: :null_session

  ENDPOINT = PpClassic::ENDPOINT_NVP_SIG

  def index
    @res = nil
    session[:is_us] = params[:is_us]
    @is_us = set_is_us(params, session)
    @merchant_id = 'GML6GZVPKKSGS'
    @merchant_id = 'UXTTV2MAAJDJE' if @is_us
  end

  def agree
    session[:is_us] = params[:is_us] if params.has_key?(:is_us)

    base_url = request.url.sub(request.fullpath, '') + '/qr'

    is_us = set_is_us(params, session)

    callback = params[:callback]
    session[:callback] = callback

    query = 'PAYMENTREQUEST_0_AMT=0&L_BILLINGTYPE0=MerchantInitiatedBilling'

    res = PpClassic.set_EC(base_url + '/createba', callback, query, endpoint: ENDPOINT, commit: false,
      context: true, is_us: is_us)

    p "==================agree: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      redirect_to(res['_MY_REDIRECT'])
    else
      @res = res
      render template: 'qr/index'
    end
  end

  def createba
    @is_us = set_is_us(params, session)

    res = PpClassic.create_BA(params[:token], endpoint: ENDPOINT, is_us: @is_us)

    p "==================createba #{res}"

    @res = res

    redirect_to(session[:callback])
  end

end
