class LgController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    @client_id = PpRest::API_APP_REST
    @redirect_uri = PpRest::API_APP_REST_URI
    @access_token = params[:access_token]
    @refresh_token = params[:refresh_token]
    @res = nil
    if @access_token.present? then
      @res = session[:res]
    end
  end

  def callback
    base_url = request.url.sub(request.fullpath, '')
    if params[:token].present? then
      url = base_url + "/rest?"
      params.each do |k, v|
        url += "#{k}=#{v}&"
      end
      redirect_to url
      return
    end

    code = params[:code]

    p "==================callback code: #{code}"

    #res = PpRest.identity(code)
    res = PpRest.get_token2(code)

    p "==================callback res: #{res}"

    token = res['access_token']

    refresh_token = res['refresh_token']

    res = PpRest.userinfo(token)

    p "==================callback (userinfo) res: #{res}"

    session[:res] = res

    render :text => "<script>if (top.window.opener != null) { top.window.opener.location='#{base_url}/lg?access_token=#{token}&refresh_token=#{refresh_token}'; " +
      "window.close(); } else { window.location='#{base_url}/lg?access_token=#{token}&refresh_token=#{refresh_token}'; } </script>"

  end

  def userinfo

    access_token = params[:access_token]

    res = PpRest.userinfo(access_token)

    p "==================userinfo res: #{res}"

    @res = res
    render template: 'lg/index'
  end

  def auth

    # redirect_to("https://www.sandbox.paypal.com/signin/authorize" +
    #  "?client_id=#{PpRest::API_APP_REST}&response_type=code&scope=openid+profile+email+address+phone" +
    #    "+https%3A%2F%2Furi.paypal.com%2Fservices%2Fpaypalattributes+https%3a%2f%2furi%2epaypal%2ecom%2fservices%2finvoicing&redirect_uri=#{PpRest::API_APP_REST_URI}")

    redirect_to("https://www.sandbox.paypal.com/signin/authorize" +
      "?client_id=#{PpRest::API_APP_REST}&response_type=code&scope=openid+profile+email+address+phone" +
        "+https%3A%2F%2Furi.paypal.com%2Fservices%2Fpaypalattributes+https%3a%2f%2furi%2epaypal%2ecom%2fservices%2finvoicing&redirect_uri=#{PpRest::API_APP_REST_URI}")

  end
end
