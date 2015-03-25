module ClHelper

  def show_res(method, res)
    success = false
    success = true if res['ACK'] == 'Success'
    div_class = success ? 'alert-success' : 'alert-danger'
    msg = success ? "Success!" : "Error!"
    html = '<p>' +
    '<div class="alert ' + div_class + '" role="alert">' + msg + '</div>' +
    '<p>' + method + '</p>' +
    '<p>' + res + '</p>' +
    '</p>'
    html
  end

end
