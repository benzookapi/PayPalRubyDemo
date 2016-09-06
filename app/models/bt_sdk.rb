class BtSdk

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
    gateway = Braintree::Gateway.new(:access_token => 'access_token$sandbox$btdxhpwfbt6dy2vt$41c6f24f692e018e2c68d84ce235fe79')
    gateway.client_token.generate
  end

  def self.doTrans(nonce, amount)
    result = Braintree::Transaction.sale(:amount => amount, :payment_method_nonce => nonce)
    result
  end

  def self.doTransEC(nonce, amount, currency)
    gateway = Braintree::Gateway.new(:access_token => 'access_token$sandbox$btdxhpwfbt6dy2vt$41c6f24f692e018e2c68d84ce235fe79')
    result = gateway.transaction.sale(:amount => amount, :payment_method_nonce => nonce, :merchant_account_id => currency)
    result
  end
end
