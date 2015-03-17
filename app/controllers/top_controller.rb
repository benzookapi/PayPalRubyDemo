class TopController < ApplicationController

  def main
    #nothing
  end

  def xo

    url = Pp.setEC(request.url, request.url, 5)

    redirect_to(url)

  end

end
