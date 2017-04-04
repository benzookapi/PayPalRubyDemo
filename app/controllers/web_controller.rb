class WebController < ApplicationController

  protect_from_forgery with: :null_session

  ENDPOINT = PpClassic::ENDPOINT_NVP_SIG

  def index
    p "==================index: #{params}"
    @res = nil
    session[:is_us] = params[:is_us]
    session[:q_context] = "PAYMENTREQUEST_0_AMT=0&L_BILLINGTYPE0=MerchantInitiatedBillingSingleAgreement"
    @is_us = set_is_us(params, session)
    @merchant_id = 'GML6GZVPKKSGS'
    @merchant_id = 'UXTTV2MAAJDJE' if @is_us
    @locale = "ja_JP"
    @locale = 'en_US' if @is_us
    @context_params = "container: 'myContainer'"
    @button = ""
    if params[:is_button].present? then
      @context_params = "button: ['t1']"
      @button = "<button id='t1' type='submit'>Button</button>"
    end
  end

  def checkout
    session[:is_us] = params[:is_us] if params.has_key?(:is_us)

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/web'

    is_us = set_is_us(params, session)

    query = params[:q_context]

    session[:q_context] = query

    commit = (query.include?("PAYMENTREQUEST_0_AMT=0") == true ? false : true)

    redirect = (params.has_key?(:redirect) && params[:redirect] == 'false' ? false : true)

    res = PpClassic.set_EC(callback + '/complete', callback + '?is_us=' + is_us.to_s, query, endpoint: ENDPOINT, commit: commit,
      context: (params[:context] == 'true' ? true : false), is_us: is_us)

    p "==================checkout: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      redirect_to(res['_MY_REDIRECT']) if redirect
      render :json => {'token': res['TOKEN']}  if !redirect
    else
      @res = res
      render template: 'web/index'
    end
  end

  def complete
    @is_us = set_is_us(params, session)

    query = session[:q_context]

    if !query.include?("PAYMENTREQUEST_0_AMT=0") then
      res = PpClassic.do_EC(params[:token], params[:PayerID], query, endpoint: ENDPOINT, is_us: @is_us)
      p "==================complete #{res}"
      @res = res
    end

    if query.include?("MerchantInitiatedBilling") then
      res = PpClassic.create_BA(params[:token], endpoint: ENDPOINT, is_us: @is_us)
      @res = res
    end

    render template: 'web/complete'
  end
end
