module ApplicationHelper

  def show_endpoint(endpoint)
    html = '<select class="form-control"  id="e_p">'
    html += '<option value="' + PpClassic::ENDPOINT_NVP_SIG + '" '
    if endpoint == PpClassic::ENDPOINT_NVP_SIG then
      html += 'selected'
    end
    html += '>NVP Signature</option>'
    html += '<option value="' + PpClassic::ENDPOINT_NVP_CER + '" '
    if endpoint == PpClassic::ENDPOINT_NVP_CER then
      html += 'selected'
    end
    html += '>NVP Certificate</option>'
    html += '<option value="' + PpClassic::ENDPOINT_NVP_CER_CDN + '" '
    if endpoint == PpClassic::ENDPOINT_NVP_CER_CDN then
      html += 'selected'
    end
    html += '>NVP Certificate (new beta)</option>'
    html += '</select>'
    html
  end

  def show_ua(stored_ua, ua)
    color = stored_ua == ua ? '' : 'class="text-danger"'
    msg = stored_ua == ua ? '' : 'changed!'
    html = '<p>User-Agent Request Header: <span ' + color + '>' + ua + ' ' + msg + '</span></p>'
    html
  end

  def show_res(method, res)
    if res == nil then
      res = {}
    end
    ack = res['ACK'] != nil ? res['ACK'] : res['responseEnvelope.ack'] != nil ?
      res['responseEnvelope.ack'] : res['message'] == nil ? 'Success' : 'Failure'

    div_class = ''
    case ack
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
    when 'Pay' then
        detail = 'https://developer.paypal.com/webapps/developer/docs/classic/api/adaptive-payments/Pay_API_Operation/'
    when 'ExecutePayment' then
        detail = 'https://developer.paypal.com/docs/classic/api/adaptive-payments/ExecutePayment_API_Operation/'
    when 'PaymentDetails' then
        detail = 'https://developer.paypal.com/docs/classic/api/adaptive-payments/PaymentDetails_API_Operation/'
    when 'Refund' then
        detail = 'https://developer.paypal.com/docs/classic/api/adaptive-payments/Refund_API_Operation/'
    when 'Preapproval' then
        detail = 'https://developer.paypal.com/docs/classic/api/adaptive-payments/Preapproval_API_Operation/'
    when 'Create a payment' then
        detail = 'https://developer.paypal.com/docs/api/#create-a-payment'
    when 'Execute an approved PayPal payment' then
        detail = 'https://developer.paypal.com/docs/api/#execute-an-approved-paypal-payment'
    when 'Execute payouts' then
        detail = 'https://developer.paypal.com/docs/api/#payouts'
    when 'Call a NVP(Classic) API' then
        detail = 'https://developer.paypal.com/docs/classic/api/#ec'
    else
        detail = 'https://developer.paypal.com/docs/api/'
    end

    msg = ack + ', elapsed (sec.): ' + res['_MY_ELAPSED_TIME'].to_s
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
