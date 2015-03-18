class TopController < ApplicationController

  def main

  end

  def set

    base_url = request.url.sub(request.fullpath, "")

    url = Pp.setEC(base_url + "/xo", base_url + "/err", 100)

    p "==================set redirect url: #{url}"

    redirect_to(url)

  end

  def pay

    token = params[:token]

    payer_id = params[:PayerID]

    p "==================pay token: #{token}"
    p "pay payer_id: #{payer_id}"

    p "==================getEC #{Pp.getEC(token)}"

    p "==================doEC #{Pp.doEC(token, payer_id, 100)}"

    render action: :main

  end

  def error

  end

end
