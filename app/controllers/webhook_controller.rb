require 'uri'
require 'net/http'

class WebhookController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    query = ''
    params.map {|k, v| query += "#{k}=#{v}&" if k != 'controller' && k != 'action'}
    query.chop!

    p "==================Webhook received data: #{query}"

    charset = params[:charset].blank? ? 'UTF-8' : params[:charset]

    p "==================Webhook charset: #{charset}"

    if charset != 'UTF-8' then
      query = query.encode('UTF-8', charset)
    end

    q = URI.escape(query).gsub('+', '%2B')

    q += '&cmd=_notify-validate'

    p "==================Webhook verification request: #{q}"


    render :text => "<h4>Not Verified!</h4><p>#{query}</p>"

  end

end
