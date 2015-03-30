class RtnController < ApplicationController

  def index


    render :text => "#{params}"

  end
end
