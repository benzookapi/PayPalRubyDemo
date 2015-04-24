class AdController < ApplicationController

  def index

  end

  def pay
    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/ad'

    res = PpAdaptive.pay(callback + '?st=redirect', callback + '?st=cancel', params[:q_pay])

    p "==================pay: #{res}"
    @res = res
    render template: 'ad/index'
  end

end
