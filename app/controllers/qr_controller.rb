require 'barby'
require 'barby/barcode'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'

class QrController < ApplicationController

  protect_from_forgery with: :null_session

  ENDPOINT = PpClassic::ENDPOINT_NVP_SIG

  def agree

    base_url = request.url.sub(request.fullpath, '') + '/qr'

    callback = params[:callback]
    session[:callback] = callback

    query = 'PAYMENTREQUEST_0_AMT=0&L_BILLINGTYPE0=MerchantInitiatedBilling'

    res = PpClassic.set_EC(base_url + '/createba', callback, query, endpoint: ENDPOINT, commit: false,
      context: (params[:context] == 'true' ? true : false), is_us: true)

    p "==================agree: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      redirect_to(res['_MY_REDIRECT'])
    else
      redirect_to(session[:callback] + "?ba=false")
    end
  end

  def createba

    token = params[:token]

    res = PpClassic.get_EC(token, endpoint: ENDPOINT, is_us: true)

    p "==================createba get_EC: #{res}"

    to = res['EMAIL']

    res = PpClassic.create_BA(token, endpoint: ENDPOINT, is_us: true)

    p "==================createba create_BA: #{res}"

    html = "TEST! #{res}"

    ba = res['BILLINGAGREEMENTID']

    from = "benzookapi-noreply@gmail.com"

    subject = "Your PayPal QR Ticket!"

    qrcode = Barby::QrCode.new(ba, level: :q, size: 5)

    file = "./tmp/qrcode_#{Time.now}.png".gsub(" " , "")

    File.open(file, 'wb') do |f|
        f.write qrcode.to_png({ xdim: 5 })
    end
    #base64_output = Base64.encode64(qrcode.to_png({ xdim: 5 }))
    #p "==================createba encode64: #{base64_output}"
    #  "<img src=\"data:image/png;base64,#{base64_output}\"  alt=\"qrcode\">"

    html = "Thank you for getting your QR Ticket. Here is yours:<br/>"

    PpEmail.send_QR(to, from, subject, html, file)

    redirect_to(session[:callback] + "?ba=true")
  end

  def pay
    ba = params[:ba]
    amt = params[:amt]
    query = "AMT=#{amt}&PAYMENTACTION=Sale&CURRENCYCODE=JPY"
    res = PpClassic.do_RT(ba, query, endpoint: ENDPOINT, is_us: true)
    render :text =>  "#{res}"
  end

end
