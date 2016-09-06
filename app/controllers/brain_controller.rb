class BrainController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    @client_token = BtSdk.getToken('mytestaaa123')

    @client_token_ec = BtSdk.getTokenEC()

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
    result = BtSdk.doTransEC(params[:payment_method_nonce], params[:amount], params[:currency])
    @sucess_ec = result.success?
    @status_ec = result.transaction.status
    @transaction_ec = result.transaction

    p "==================checkout_ec result: #{@success_ec} #{@status_ec} #{@transaction_ec}"

    render :template => 'brain/index'

  end
end
