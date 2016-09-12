class BrainController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    @client_token = BtSdk.getToken('mytestaaa123')

    @client_token_ec = BtSdk.getTokenEC()

    @customer_id = ''

    p "==================index token: #{@client_token}"
    p "==================index token for EC: #{@client_token_ec}"

  end

  def checkout

    result = BtSdk.doTrans(params[:payment_method_nonce], params[:amount])

    @sucess = result.success?
    @status = result.transaction.status

    p "==================checkout result: #{@success} #{@status}"

    render :template => 'brain/index'
  end

  def checkout_ec
    result = BtSdk.doTransEC(params[:payment_method_nonce], params[:amount], params[:currency], deviceData: params[:device_data])
    @sucess_ec = result.success?
    @status_ec = result.transaction.status
    @customer_id = result.transaction.customer_details.id
    @transaction_ec = "Transaction Id (in BT): #{result.transaction.id} Customer Id (in BT): #{@customer_id}"

    p "==================checkout_ec result: #{@success_ec} #{@status_ec} #{@transaction_ec}"

    render :template => 'brain/index'

  end

  def vault
    result = BtSdk.doTransVault(params[:vault_customer_id], params[:vault_amount], params[:vault_currency])
    @success_vault = result.success?
    @status_vault = result.transaction.status
    @customer_id = result.transaction.customer_details.id
    @transaction_vault = "Transaction Id (in BT): #{result.transaction.id} Customer Id (in BT): #{@customer_id}"

    p "==================vault result: #{@success_vault} #{@status_vault} #{@transaction_vault}"

    render :template => 'brain/index'

  end
end
