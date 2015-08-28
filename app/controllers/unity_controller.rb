class UnityController < ApplicationController

  protect_from_forgery with: :null_session

  ENDPOINT = PpClassic::ENDPOINT_NVP_CER

  def index
    is_comp = params[:is_comp]

    if is_comp == 'true' then
      token = params[:token]
      res = PpClassic.create_BA(token, endpoint: ENDPOINT, is_us: false)
      ba = res['BILLINGAGREEMENTID']
      PpClassic.do_RT(ba, "AMT=1000&PAYMENTACTION=Sale&CURRENCYCODE=JPY", endpoint: ENDPOINT, is_us: false)
      return render :text =>  "YOUR ACCESS KEY: #{ba}"
    end

    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/unity'

    query = 'PAYMENTREQUEST_0_AMT=1000&PAYMENTREQUEST_0_CURRENCYCODE=JPY&L_BILLINGTYPE0=MerchantInitiatedBilling&PAYMENTREQUEST_0_DESC=Unity And PayPal Demo Game Access Key&NOSHIPPING=1'

    res = PpClassic.set_EC(callback + '?is_comp=true', callback + '?is_comp=false', query, endpoint: ENDPOINT, commit: true,
      context: true, is_us: false)

    p "==================checkout: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      redirect_to(res['_MY_REDIRECT'])
    else
      render :text =>  "#{res}"
    end
  end

  def pay
    email = params[:email]
    amt = params[:amt]
    query = "RECEIVERTYPE=EmailAddress&L_EMAIL0=#{email}&L_AMT0=#{amt}&CURRENCYCODE=JPY"
    res = PpClassic.masspay(query, endpoint: ENDPOINT, is_us: false)
    render :text =>  "#{res}"
  end

  def charge
    ba = params[:ba]
    amt = params[:amt]
    query = "AMT=#{amt}&PAYMENTACTION=Sale&CURRENCYCODE=JPY"
    res = PpClassic.do_RT(ba, query, endpoint: ENDPOINT, is_us: false)
    render :text =>  "#{res}"
  end
end
