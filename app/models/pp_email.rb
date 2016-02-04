require 'sendgrid-ruby'

class PpEmail

  SENDGRID_KEY = ENV['SENDGRID_KEY']

  def self.send_QR(to, from, subject, html, file)

    client = SendGrid::Client.new(api_key: SENDGRID_KEY)

    mail = SendGrid::Mail.new do |m|
      m.to = to
      m.from = from
      m.subject = subject
      m.html = html + '<div><img src="cid:ppqr"></div>'
    end
    mail.add_content(file, 'ppqr')

    res = client.send(mail)

    p "==================send_QR res: #{res.code} #{res.body}"

    res
  end
end
