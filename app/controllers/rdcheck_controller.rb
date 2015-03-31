class RdcheckController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    redirect_to "#{params[MY_REDIRECT]}"

  end
end
