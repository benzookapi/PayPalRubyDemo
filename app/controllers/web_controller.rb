class WebController < ApplicationController

  protect_from_forgery with: :null_session

  ENDPOINT = PpClassic::ENDPOINT_NVP_SIG

  def index
    @res = nil
    session[:is_us] = params[:is_us]
  end

  def checkout
    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/web'

    query = 'PAYMENTREQUEST_0_AMT=300&PAYMENTREQUEST_0_CURRENCYCODE=JPY'
    #query = 'L_BILLINGTYPE0=MerchantInitiatedBilling&PAYMENTREQUEST_0_AMT=3000&PAYMENTREQUEST_0_CURRENCYCODE=JPY'
    #query = 'L_BILLINGTYPE0=RecurringPayments&L_BILLINGAGREEMENTDESCRIPTION0=定期支払いです！&PAYMENTREQUEST_0_AMT=3000&PAYMENTREQUEST_0_CURRENCYCODE=JPY'

    res = PpClassic.set_EC(callback + '/complete', callback + '', query, ENDPOINT, true,
      params[:context] == 'true' ? true : false, set_is_us(params, session))

    p "==================checkout: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      redirect_to(res['_MY_REDIRECT'])
    else
      @res = res
      render template: 'web/index'
    end
  end

  def complete
    query = 'PAYMENTREQUEST_0_AMT=3000&PAYMENTREQUEST_0_CURRENCYCODE=JPY'

    res = PpClassic.do_EC(params[:token], params[:PayerID], query, ENDPOINT, set_is_us(params, session))

    p "==================complete #{res}"

    @res = res

    render template: 'web/complete'

  end
end
