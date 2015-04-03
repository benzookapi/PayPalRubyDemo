module ClHelper

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
    html = '<p>User-Agent Request Header: <span ' + color + '>' + ua + '</span></p>'
    html
  end

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

end
