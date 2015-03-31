class RdcheckController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    @ug = params.has_key?(:ug) ? params[:ug] : ''

    render template: 'rdcheck/index'
  end

  def rd

    redirect_to "#{params[:rd]}"

  end
end
