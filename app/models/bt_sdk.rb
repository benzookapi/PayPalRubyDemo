class BtSdk

  TOKEN_JP_PRO = 'access_token$sandbox$btdxhpwfbt6dy2vt$41c6f24f692e018e2c68d84ce235fe79'

  TOKEN_US_PRO = 'access_token$sandbox$8zbxpg8bdwpbwgv3$d0555a86a3e36eb3b088a194d02a2b1a'

  TOKEN_JP_NORMAL = 'access_token$sandbox$rrmfw6c4w3yps6t3$9a1ca6d71b74db5c5be6d16ffd395348'

  TOKEN_LIVE = ENV['PP_BT_TOKEN']

  MY_TOKEN = TOKEN_JP_PRO
  #MY_TOKEN = TOKEN_LIVE

  def self.getToken(customer_id)
    Braintree::Configuration.environment = :sandbox
    Braintree::Configuration.merchant_id = "sqhrsttx42vpt63j"
    Braintree::Configuration.public_key = "xwztjydf2g7zkdsw"
    Braintree::Configuration.private_key = "532d0a43a6ca6796b77d824ea60f88e0"
    #Braintree::Configuration.merchant_id = "kxfwg6w9hrrp7dtk"
    #Braintree::Configuration.public_key = "744fsgs5zws2zx3h"
    #Braintree::Configuration.private_key = "24311ba6a970ce6475ab9e48f81be87d"
    client_token = Braintree::ClientToken.generate
    #client_token = Braintree::ClientToken.generate(:customer_id => customer_id)
    client_token
  end

  def self.getTokenEC()
    gateway = Braintree::Gateway.new(:access_token => MY_TOKEN)
    gateway.client_token.generate
  end

  def self.doTrans(nonce, amount)
    result = Braintree::Transaction.sale(:amount => amount, :payment_method_nonce => nonce)
    result
  end

  def self.doTransEC(nonce, amount, currency, deviceData: '', payee: '', bncode: '', submit: true)
    gateway = Braintree::Gateway.new(:access_token => MY_TOKEN)
    result = gateway.transaction.sale(:amount => amount, :payment_method_nonce => nonce, :merchant_account_id => currency,
      :device_data => deviceData, :options => {:submit_for_settlement => submit, :store_in_vault_on_success => true,
        :paypal => {:payee_email => payee}}, :channel => bncode)
    result
  end

  def self.createCS(nonce, deviceData: '')
    gateway = Braintree::Gateway.new(:access_token => MY_TOKEN)
    result = gateway.customer.create(:payment_method_nonce => nonce, :device_data => deviceData)
    result
  end

  def self.doTransVault(customer_id, amount, currency, billingId: '', shippingId: '', payee: '', bncode: '', submit: true)
    gateway = Braintree::Gateway.new(:access_token => MY_TOKEN)
    result = gateway.transaction.sale(:customer_id => customer_id, :amount => amount, :merchant_account_id => currency,
      :options => {:submit_for_settlement => submit, :paypal => {:payee_email => payee}}, :channel => bncode)
    result
  end

  def self.search(customer_id, id)
    gateway = Braintree::Gateway.new(:access_token => MY_TOKEN)
    collection = gateway.transaction.search do |search|
      search.customer_id.is customer_id
      search.id.is id
    end
    result = []
    collection.each do |transaction|
      result.push(transaction.inspect + " " + transaction.paypal_details.inspect + " " + transaction.shipping_details.inspect)
    end
    result
  end

  def self.refund(id)
    gateway = Braintree::Gateway.new(:access_token => MY_TOKEN)
    result = gateway.transaction.refund(id)
    result
  end

  def self.capture(id)
    gateway = Braintree::Gateway.new(:access_token => MY_TOKEN)
    result = gateway.transaction.submit_for_settlement(id)
    result
  end
end
