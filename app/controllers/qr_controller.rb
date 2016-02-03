class QrController < ApplicationController

  protect_from_forgery with: :null_session

  ENDPOINT = PpClassic::ENDPOINT_NVP_SIG

  def agree

    base_url = request.url.sub(request.fullpath, '') + '/qr'

    callback = params[:callback]
    session[:callback] = callback

    query = 'PAYMENTREQUEST_0_AMT=0&L_BILLINGTYPE0=MerchantInitiatedBilling'

    res = PpClassic.set_EC(base_url + '/createba', callback, query, endpoint: ENDPOINT, commit: false,
      context: true, is_us: true)

    p "==================agree: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      redirect_to(res['_MY_REDIRECT'])
    else
      redirect_to(session[:callback])
    end
  end

  def createba

    res = PpClassic.create_BA(params[:token], endpoint: ENDPOINT, is_us: true)

    p "==================createba #{res}"

    html = "TEST! #{res}"

    res = PpEmail.send_QR("jokksk@gmail.com", "benzookapi-noreply@gmail.com", "Your Ticket!", html)

    p "==================createba email: #{res}"

    redirect_to(session[:callback])
  end

end
