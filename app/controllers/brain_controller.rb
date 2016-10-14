class BrainController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    @client_token = BtSdk.getToken('mytestaaa123')

    @client_token_ec = BtSdk.getTokenEC()

    @css_ec = 'info'
    @css_vault = 'info'

    session[:amount] = params[:amount].blank? ? 100 : params[:amount]
    session[:currency] = params[:currency].blank? ? 'JPY' : params[:currency]
    session[:is_vault] = params[:is_vault].blank? ? '' : 'true'
    session[:is_submit] = params[:is_submit].blank? ? '' : 'false'

    p "==================index token: #{@client_token}"
    p "==================index token for EC: #{@client_token_ec}"
    p "==================index amount, currency and is_vault: #{session[:amount]} #{session[:currency]} #{session[:is_vault]}"

  end

  def get_token
    render :text => BtSdk.getTokenEC()
  end

  def checkout

    result = BtSdk.doTrans(params[:payment_method_nonce], params[:amount])

    @sucess = result.success?
    @status = result.transaction.status
    @tran_res = result.transaction.inspect

    p "==================checkout result: #{@success} #{@status} #{@tran_res}"

    render :template => 'brain/index'
  end

  def checkout_ec

    p "==================checkout_ec amount and currency: #{session[:amount]} #{session[:currency]}"

    deviceData = params[:device_data].blank? ? '' : params[:device_data]
    @payee = params[:payee].blank? ? '' : params[:payee]
    @bncode = params[:bncode].blank? ? '' : params[:bncode]

    result = BtSdk.doTransEC(params[:payment_method_nonce], params[:amount], params[:currency], deviceData: deviceData, payee: @payee, bncode: @bncode)
    @sucess_ec = result.success?
    @err_ec = ''
    @css_ec = 'info'
    if defined? result.errors then
      result.errors.each do |error|
        @err_ec = @err_ec + error.inspect + " "
        @css_ec = 'danger'
      end
    end

    @status_ec = ''
    @customer_id = ''
    @transaction_ec = ''
    @tran_res_ec = ''
    if @err_ec.blank? then
      @status_ec = result.transaction.status
      @customer_id = result.transaction.customer_details.id
      @transaction_ec = "Transaction Id (in BT): #{result.transaction.id} Customer Id (in BT): #{@customer_id}"

      @tran_res_ec = result.transaction.inspect + " " + result.transaction.paypal_details.inspect
    end

    p "==================checkout_ec result: #{@err_ec} #{@success_ec} #{@status_ec} #{@transaction_ec} #{@tran_res_ec}"

    render :template => 'brain/index'

  end

  def create_cs
    deviceData = params[:device_data].blank? ? '' : params[:device_data]

    p "==================create_cs payment_method_nonce device_data: #{params[:payment_method_nonce]} #{deviceData}"


    result = BtSdk.createCS(params[:payment_method_nonce],deviceData: deviceData)

    p "==================create_cs result: #{result.inspect}"

    @sucess_ec = result.success?
    @err_ec = ''
    @css_ec = 'info'
    if defined? result.errors then
      result.errors.each do |error|
        @err_ec = @err_ec + error.inspect + " "
        @css_ec = 'danger'
      end
    end

    #@status_ec = ''
    @customer_id = ''
    #@transaction_ec = ''
    @tran_res_ec = result.inspect
    if @err_ec.blank? then
      @customer_id = result.customer.id
      @tran_res_ec = result.customer.inspect + " " + result.customer.paypal_accounts.inspect
    end

    render :template => 'brain/index'

  end

  def vault
    @payee = params[:payee].blank? ? '' : params[:payee]
    @bncode = params[:bncode].blank? ? '' : params[:bncode]

    result = BtSdk.doTransVault(params[:vault_customer_id], params[:vault_amount], params[:vault_currency], payee: @payee, bncode: @bncode)
    @success_vault = result.success?
    @err_vault = ''
    @css_vault = 'info'
    if defined? result.errors then
      result.errors.each do |error|
        @err_vault = @err_vault + error.inspect + " "
        @css_vault = 'danger'
      end
    end

    @status_vault = ''
    @customer_id = ''
    @transaction_vault = ''
    @tran_res_vault = ''
    if @err_vault.blank? then
      @status_vault = result.transaction.status
      @customer_id = result.transaction.customer_details.id
      @transaction_vault = "Transaction Id (in BT): #{result.transaction.id} Customer Id (in BT): #{@customer_id}"

      @tran_res_vault = result.transaction.inspect + " " + result.transaction.paypal_details.inspect
    end

    p "==================vault result: #{@err_vault} #{@success_vault} #{@status_vault} #{@transaction_vault} #{@tran_res_vault}"

    render :template => 'brain/index'

  end

  def search
    @customer_id = params[:customer_id]
    @id = params[:id]
    result = BtSdk.search(@customer_id, @id)

    @search_res = result.inspect

    p "==================search result: #{@search_res}"

    render :template => 'brain/index'

  end

  def refund
    @id = params[:id]
    result = BtSdk.refund(@id)

    @success_refund = result.success?

    @refund_res = result.transaction.inspect + " " + result.transaction.paypal_details.inspect

    p "==================refund result: #{@success_refund} #{@refund_res}"

    render :template => 'brain/index'

  end
end
