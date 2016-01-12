require 'uri'
require 'net/http'

class IpnController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    query = ''
    params.map {|k, v| query += "#{k}=#{v}&" if k != 'controller' && k != 'action'}
    query.chop!

    p "==================IPN received data: #{query}"

    charset = params[:charset].blank? ? 'UTF-8' : params[:charset]

    p "==================IPN charset: #{charset}"

    if charset != 'UTF-8' then
      query = query.encode('UTF-8', charset)
    end

    q = URI.escape(query).gsub('+', '%2B')

    q += '&cmd=_notify-validate'

    p "==================IPN verification request: #{q}"

    verify_url = PpClassic::CMD_URL

    p "==================IPN verification url: #{verify_url}"

    uri = URI.parse(verify_url)

    https = Net::HTTP.new(uri.host, 443)

    https.set_debug_output $stderr

    https.use_ssl = true

    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    result = https.post(uri.path, q).body

    p "==================IPN varification response: #{result}"

    if result == 'VERIFIED' then
      # I know this is aout of Rails styles...
      check_sql = "SELECT relname FROM pg_class WHERE relkind = 'r' AND relname = 'ipn'"
      check = ActiveRecord::Base.connection.execute(check_sql).to_a
      if check.blank? then
        ActiveRecord::Base.connection.create_table(:ipn) do |t|
          t.column :dump, :JSON
        end
        p "==================ipn table created."
      end
      insert_json = "{"
      params.map {|k, v| insert_json += "\"#{k}\" : \"#{v}\"," if k != 'controller' && k != 'action'}
      insert_json.chop!
      insert_json += "}"
      p "==================IPN json: #{insert_json}"
      insert_sql = "INSERT INTO ipn (dump) VALUES ('#{insert_json}')"
      ActiveRecord::Base.connection.update(insert_sql)
      render :text => "<h4>Verified!</h4><p>#{query}</p>"
    else
      render :text => "<h4>Not Verified!</h4><p>#{query}</p>"
    end
  end

  def indexget

    render template: 'ipn/index'

  end
end
