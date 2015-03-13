class TopController < ApplicationController

  def main
    #nothing
  end

  def xo
    p "================" + params["id"]
    render :text => "OK"

  end


end
