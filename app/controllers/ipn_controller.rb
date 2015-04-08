class IpnController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    p "==================index #{request}"

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
