class IpnController < ApplicationController

  protect_from_forgery with: :null_session

  def index


    render :text => "#{params}"

  end
end
