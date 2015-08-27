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

sample_err_rp=<<'SAMPLE_ERR_RP'
payment_cycle=Daily&txn_type=recurring_payment_failed&last_name=test&next_payment_date=03:00:00 Aug 26, 2015 PDT&residence_country=JP&<br/>
initial_payment_amount=0.00&currency_code=USD&time_created=23:48:26 May 21, 2015 PDT&<br/>
verify_sign=AmrZscqAufOBlvUqnx80IjZKdPlyAzkmVnvr-RpGiPLppxjeZfvC6.ou&period_type= Regular&payer_status=unverified&test_ipn=1&tax=0.00&<br/>
payer_email=hogehoge+P0522@gmail.com&first_name=test&receiver_email=hogehoge+B@gmail.com&payer_id=RVFDEMDQ9WA7G&product_type=1&shipping=0.00&<br/>
amount_per_cycle=102.00&profile_status=Active&charset=UTF-8&notify_version=3.8&amount=102.00&outstanding_balance=9690.00&<br/>
recurring_payment_id=I-GR2J9UD2PAK3&product_name=MY_RECURRSIVE_PAYMENT_102&ipn_track_id=cddc113ab08fb
SAMPLE_ERR_RP

    render :text => "<h4>Received Message Sample</h4><p>Normal payment</p><p>#{sample_ec}</p><p>Error in RP</p><p>#{sample_err_rp}</p>"
  end
end
