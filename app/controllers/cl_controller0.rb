class ClController < ApplicationController

  def index

  end

  def set
    base_url = request.url.sub(request.fullpath, '')

    url = Pp.set_ec(base_url + '/xo?q_d=' + params[:q_d],
      base_url + '/err?q_s=' + params[:q_s], URI.unescape(params[:q_s]))

    p "==================set_ec: #{url}"

    if url.start_with?('http') then
      redirect_to(url)
    else
      flash[:ec_msg] = 'Error!'
      flash[:method] = 'setExpressCheckout'
      flash[:res] = url
      render action: :main
    end
  end

  def pay
    # flash.now[:return_url] = request.url.sub(request.fullpath, "")

    token = params[:token]

    payer_id = params[:PayerID]

    p "==================pay token: #{token}"
    p "pay payer_id: #{payer_id}"

    res_do = Pp.do_ec(token, payer_id, URI.unescape(params[:q_d]))

    p "==================do_ec #{res_do}"

    flash[:method] = 'doExpressCheckoutPayment'
    flash[:res] = res_do.to_s

    if res_do['ACK'] == 'Success' then
      flash[:ec_msg] = 'Success!'
    else
      flash[:ec_msg] = 'Error!'
    end

    render action: :main
  end

  def get
    token = params[:token]

    res_get = Pp.get_ec(token)

    p "==================get_ec #{res_get}"

    render text: res_get.to_s
  end

  def error

  end

end
