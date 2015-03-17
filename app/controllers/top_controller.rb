class TopController < ApplicationController

  def main
    #nothing
  end

  def xo

    pp = Pp.new()

    url = pp.setEC(request.url, request.url, 5)

    redirect_to(url)

  end

end
