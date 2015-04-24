module AdHelper

  def show_res(method, res)
    div_class = ''
    case res['ACK']
    when 'Success' then
      div_class = 'alert-success'
    when 'SuccessWithWarning' then
      div_class = 'alert-warning'
    when 'Failure' then
      div_class = 'alert-danger'
    end

    detail = ''
    case method
    when 'SetExpressCheckout' then
      detail = 'https://developer.paypal.com/docs/classic/api/merchant/SetExpressCheckout_API_Operation_NVP/'
    when 'GetExpressCheckoutDetails' then
      detail = 'https://developer.paypal.com/docs/classic/api/merchant/GetExpressCheckoutDetails_API_Operation_NVP/'
    when 'DoExpressCheckoutPayment' then
      detail = 'https://developer.paypal.com/docs/classic/api/merchant/DoExpressCheckoutPayment_API_Operation_NVP/'
    when 'CreateRecurringPaymentsProfile' then
      detail = 'https://developer.paypal.com/docs/classic/api/merchant/CreateRecurringPaymentsProfile_API_Operation_NVP/'
    when 'TransactionSearch' then
      detail = 'https://developer.paypal.com/docs/classic/api/merchant/TransactionSearch_API_Operation_NVP/'
    when 'TransactionSearch' then
      detail = 'https://developer.paypal.com/docs/classic/api/merchant/GetTransactionDetails_API_Operation_NVP/'
    when 'GetRecurringPaymentsProfileDetails' then
      detail = 'https://developer.paypal.com/docs/classic/api/merchant/GetRecurringPaymentsProfileDetails_API_Operation_NVP/'
    when 'GetRecurringPaymentsProfileDetails' then
        detail = 'https://developer.paypal.com/docs/classic/api/merchant/CreateBillingAgreement_API_Operation_NVP/'
    when 'GetRecurringPaymentsProfileDetails' then
        detail = 'https://developer.paypal.com/docs/classic/api/merchant/DoReferenceTransaction_API_Operation_NVP/'
    end

    msg = res['ACK'] + ', elapsed (sec.): ' + res['_MY_ELAPSED_TIME'].to_s
    html = '<p>' +
    '<div class="alert ' + div_class + '" role="alert">' + msg + '</div>' +
    '<p>' + method +
    ' <a target="_blank" href="' + detail + '" >' + "details" + '</a>' +
    '</p>' +
    '<p>' + res.to_s + '</p>' +
    '</p>'
    html
  end

  def set_default_time(t, offset_sec=0, zeo_hour=false)
    hms = zeo_hour == false ? "%H:%M:%S" : "00:00:00"
    df = (Time.zone.now + offset_sec).strftime("%Y-%m-%dT" + hms + "Z")
    t.blank? ? df : t
  end

end
