class RdcheckController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    @ug = params.has_key?(:ug) ? params[:ug] : ''


    html =<<"HTML"
    <html>
    <head>
      #{@ug}
    </head>
    <body>
    <form method="POST" action="rdcheck/rd">
      <input type="hidden" name="rd" value="https://jo-static-web.herokuapp.com/ugcheck.html">
    <input type="submit" value="Redirect">
    </form>

    </body>
    </html>
HTML

    render text: html
  end

  def rd

    redirect_to "#{params[:rd]}"

  end
end
