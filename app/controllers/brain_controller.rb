class BrainController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    @client_token = BtSdk.getToken('mytestaaa123')

    p "==================index token: #{@client_token}"
  end

  def checkout

    result = BtSdk.doTrans(params[:payment_method_nonce], params[:amount])

    @sucess = result.success?
    @status = result.transaction.status

    p "==================checkout result: #{@success} #{@status}"

    render :template => 'brain/index'
  end
end
