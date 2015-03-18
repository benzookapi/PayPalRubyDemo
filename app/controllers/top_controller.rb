class TopController < ApplicationController

  def main

  end

  def set

    base_url = request.url.sub(request.fullpath, "")

    url = Pp.setEC(base_url + "/xo", base_url + "/err", 100)

    redirect_to(url)

  end

  def pay

    token = params[:token]

    payer_id = params[:PayerID]

    render :text => token + payer_id
    
  end

  def error

  end

end
