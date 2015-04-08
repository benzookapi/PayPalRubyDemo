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
sample_ec=<<'SAMPLE_EC'
mc_gross=105.02&protection_eligibility=Eligible&address_status=unconfirmed&payer_id=RPXDAMFRCMMVE<br/>
&tax=0.00&address_street=Nishi 4-chome, Kita 55-jo, Kita-ku&payment_date=10:23:50 Apr 06, 2015 PDT<br/>
&payment_status=Completed&charset=Shift_JIS&address_zip=150-0002&first_name=P&mc_fee=4.08<br/>
&address_country_code=JP&address_name=O P&notify_version=3.8&custom=&payer_status=verified<br/>
&address_country=Japan&address_city=Shibuya-ku&quantity=1<br/>
&verify_sign=AoiCBNGVMlgj2ndAkLS-nFk5d9sfAf3Q1z4f.l3WeEaz-J1iqUnTC20I<br/>
&payer_email=hogehoge+P@gmail.com&txn_id=4MC0186636400980G&payment_type=instant&<br/>
last_name=O&address_state=Tokyo&receiver_email=hogehoge+B@gmail.com<br/>
&payment_fee=4.08&receiver_id=W2RNXXPHP3YXE&txn_type=express_checkout&item_name=&mc_currency=USD<br/>
&item_number=&residence_country=JP&test_ipn=1&handling_amount=0.00&transaction_subject=MY_RECURRSIVE_PAYMENT_166<br/>
&payment_gross=105.02&shipping=0.00&ipn_track_id=3403158a234f9
SAMPLE_EC

sample_err=<<'SAMPLE_ERR'
txn_type=mp_notification&last_name=Ooo&mp_currency=USD&residence_country=JP&mp_status=0&mp_custom=&<br/>
verify_sign=AynlJ2zsmflH.74VEfIBZZJsEArxAvA4ORxE8B2zQXSXGaB.EMgfrVNz&payer_status=verified&test_ipn=1&<br/>
payer_email=hogehoge+P3@gmail.com&first_name=Jjj&payer_id=4ZSMFPMGCCBE6&reason_code=mp_2011&<br/>
mp_id=B-988374119V7692935&charset=Shift_JIS&notify_version=3.8&mp_desc=&mp_cycle_start=8&ipn_track_id=3bb5c4d39187b
SAMPLE_ERR

    render :text => "<h4>Received Message Sample</h4><p>Normal payment</p><p>#{sample_ec}</p><p>Error in RT</p><p>#{sample_err}</p>"
  end
end
