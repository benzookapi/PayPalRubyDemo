class WebController < ApplicationController

  protect_from_forgery with: :null_session

  ENDPOINT = PpClassic::ENDPOINT_NVP_SIG

  def index
    @res = nil
    session[:is_us] = params[:is_us]
    @is_us = set_is_us(params, session)
    @merchant_id = 'GML6GZVPKKSGS'
    @merchant_id = 'UXTTV2MAAJDJE' if @is_us
  end

  def checkout
    session[:is_us] = params[:is_us] if params.has_key?(:is_us)

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/web'

    is_us = set_is_us(params, session)

    query = get_amt(is_us)

    #query = 'L_BILLINGTYPE0=MerchantInitiatedBilling&PAYMENTREQUEST_0_AMT=3000&PAYMENTREQUEST_0_CURRENCYCODE=JPY'
    #query = 'L_BILLINGTYPE0=RecurringPayments&L_BILLINGAGREEMENTDESCRIPTION0=定期支払いです！&PAYMENTREQUEST_0_AMT=3000&PAYMENTREQUEST_0_CURRENCYCODE=JPY'

    res = PpClassic.set_EC(callback + '/complete', callback + '?is_us=' + is_us.to_s, query, endpoint: ENDPOINT, commit: true,
      context: (params[:context] == 'true' ? true : false), is_us: is_us)

    p "==================checkout: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      redirect_to(res['_MY_REDIRECT'])
    else
      @res = res
      render template: 'web/index'
    end
  end

  def complete
    @is_us = set_is_us(params, session)

    query = get_amt(@is_us)

    res = PpClassic.do_EC(params[:token], params[:PayerID], query, endpoint: ENDPOINT, is_us: @is_us)

    p "==================complete #{res}"

    @res = res

    render template: 'web/complete'
  end

  private
  def get_amt(is_us)
    query = 'PAYMENTREQUEST_0_AMT=300&PAYMENTREQUEST_0_CURRENCYCODE=JPY&L_BILLINGTYPE0=MerchantInitiatedBilling'
    query = 'PAYMENTREQUEST_0_AMT=3&PAYMENTREQUEST_0_CURRENCYCODE=USD&L_BILLINGTYPE0=MerchantInitiatedBilling' if is_us
    query
  end
end
