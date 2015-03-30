class IpnController < ApplicationController

  def index


    render :text => "#{params}"

  end
end
