class TopController < ApplicationController

  def main
    #nothing
  end

  def xo

    p "SSSSS"

    begin
      pp = Pp.new()
    rescue => ex
      p "#{ex}"
    end

    p "FFFFFF"

    #url = pp.setEC(request.url, request.url, 5)

    #redirect_to(url)

    render :text => "OK"

  end

end
