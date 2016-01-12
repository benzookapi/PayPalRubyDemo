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

    render :text => "<h4>Webhook JSON</h4><p>#{query}</p>"

  end

  def indexget

    render template: 'webhook/index'

  end

end
