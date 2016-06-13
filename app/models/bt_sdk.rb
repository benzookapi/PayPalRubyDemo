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

  def self.doTrans(nonce, amount)
    result = Braintree::Transaction.sale(:amount => amount, :payment_method_nonce => nonce)
    result
  end
end
