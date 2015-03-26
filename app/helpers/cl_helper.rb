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
    html += '>NVP Certificate (CDN)</option>'
    html += '</select>'
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
    msg = res['ACK'] + ', elapsed (sec.): ' + res['_MY_ELAPSED_TIME'].to_s
    html = '<p>' +
    '<div class="alert ' + div_class + '" role="alert">' + msg + '</div>' +
    '<p>' + method + '</p>' +
    '<p>' + res.to_s + '</p>' +
    '</p>'
    html
  end

end
