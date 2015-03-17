class TopController < ApplicationController

  def main
    #nothing
  end

  def xo

    p "================" + params["id"]
    p "#{request.url}"


  pp = Pp.new()

    url = pp.setEC(request.url, request.url, 1000)

    


    redirect_to(url)

  end


end
