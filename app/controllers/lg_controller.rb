class LgController < ApplicationController

  protect_from_forgery with: :null_session

  ENDPOINT = PpClassic::ENDPOINT_NVP_SIG

  def index
    @client_id = PpRest::API_APP_REST
    @redirect_uri = PpRest::API_APP_REST_URI
    @access_token = params[:access_token]

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

    res = PpRest.identity(code)

    p "==================callback res: #{res}"

    render :text => "<script>if (top.window.opener != null) { top.window.opener.location='#{base_url}/lg?access_token=#{res['access_token']}'; " +
      "window.close(); } else { window.location='#{base_url}/lg?access_token=#{res['access_token']}'; } </script>"

  end

  def seamless_ec
    base_url = request.url.sub(request.fullpath, '')

    callback = base_url + '/lg'

    is_us = set_is_us(params, session)

    access_token = params[:access_token]

    p "==================seamless_ec access_token: #{access_token}"

    query = "PAYMENTREQUEST_0_AMT=3000&PAYMENTREQUEST_0_CURRENCYCODE=JPY&IDENTITYACCESSTOKEN=#{access_token}"

    res = PpClassic.set_EC(callback, callback + '?is_us=' + is_us.to_s, query, endpoint: ENDPOINT, commit: true,
      context: (params[:context] == 'true' ? true : false), is_us: is_us)

    p "==================seamless_ec: #{res}"

    if res.has_key?('_MY_REDIRECT') then
      redirect_to(res['_MY_REDIRECT'])
    else
      @res = res
      render template: 'lg/index'
    end
  end

  def auth

    redirect_to("https://www.sandbox.paypal.com/webapps/auth/protocol/openidconnect/v1/authorize" +
      "?client_id=#{PpRest::API_APP_REST}&response_type=code&scope=profile+email+address+phone" +
        "+https%3A%2F%2Furi.paypal.com%2Fservices%2Fpaypalattributes&https%3A%2F%2Furi.paypal.com%2Fservices%2Fexpresscheckout&redirect_uri=#{PpRest::API_APP_REST_URI}")

  end
end
