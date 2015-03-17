class TopController < ApplicationController

  def main
    #nothing
  end

  def xo

    puts "wwwwwwwwwwwwwwwww"

    pp = Pp.new()

    url = pp.setEC(request.url, request.url, 5)

    p "XXXXXXXXXXXXXX"

    redirect_to(url)

  end

end
