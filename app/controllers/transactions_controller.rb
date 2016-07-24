class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => :record
  require 'nicepay'
  require 'uri'


  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end
  def bank
    @van = params[:van]
    @date = params[:date]
    @time = params[:time]
    @bank = params[:bank]
    @amount = params[:amount]
    Cart.where(:txid => params[:txid]).update_all(:state => 2)
  end

  def updatetx
      countcart = Cart.where(:user_id => current_user.id, :state => 1).count
      Cart.where(:user_id => current_user.id, :state => 1).update_all(:state => 3)
      redirect_to '/status-pemesanan'
      status = "Pembayaran telah dilakukan"
      subject = Homeitem.find(22).text2
      subject2 = Homeitem.find(22).text4
      Notifikasi.pembayaran_berhasil(current_user, status, countcart, subject, subject2).deliver_later
  end

  def record
    @transaction = Transaction.new
    if request.post?
    @transaction.post = params
      @transaction.save
    end
  end
  def cek
    @sha = Digest::SHA256.hexdigest("IONPAYTESTIONPAYTEST01201607010900547679150033F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==")
    Nicepay.iMid=('IONPAYTEST')
    Nicepay.merchantKey=('33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==')
    Nicepay.dbProcessUrl=("#{URI.parse(root_url)}/record")
    Nicepay.callBackUrl=("#{URI.parse(root_url)}/update")
    checkStatus = Nicepay::Api::CheckStatus.new(Nicepay.requestParam)
    Nicepay.setRequestParam('iMid', Nicepay.iMid)
    Nicepay.setRequestParam('referenceNo', current_user.cart.where(:state => 1).first.invoice)
    @currentcart = Cart.where(:user_id => current_user.id, :state => 1)
    @subtotal = []
    @currentcart.each do |c|
    @subtotal << c.subtotal
    end
    Nicepay.setRequestParam('amt', 3000)
    Nicepay.setRequestParam('tXid', current_user.cart.last.txid)
    Nicepay.setRequestParam('merchantToken', Nicepay.merchantTokenC)
    response = checkStatus.response
    if response["resultCd"].to_s == "0000"
        @status = response["status"].to_s
        @amount = response["amt"].to_s
        @ref = response["referenceNo"].to_s
        @trx = response["tXid"].to_s

        else
        @status = "\nOops! Check Status failed to generate! We have recorded the event. \nPlease try again later.\n\n"
        @result = response["resultCd"]
        @msg =  response["resultMsg"]
        end
      if @status == "0"
        redirect_to '/update'
      end
        Nicepay.flushParam
  end
  def va
    Nicepay.iMid=('VACCTCLOSE')
    Nicepay.merchantKey=('33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==')
    Nicepay.dbProcessUrl=("#{URI.parse(root_url)}/record")
    Nicepay.callBackUrl=("#{URI.parse(root_url)}/status-pemesanan")
    requestVa   = Nicepay::Api::RequestVa.new(Nicepay.requestParam)
    Nicepay.setRequestParam('iMid', Nicepay.iMid)
    Nicepay.setRequestParam('payMethod', '02')
    Nicepay.setRequestParam('bankCd', params[:bank])
    #@invoice = []
    #current_user.cart.where(:state => 1).each do |c|
    #  @invoice << c.invoice
    #end
    #@invoice = @invoice.to_sentence
    if current_user.cart.where(:state => 1).count > 1
    @invoice = current_user.cart.where(:state => 1).first.invoice + " - " + current_user.cart.where(:state => 1).last.invoice
    else
    @invoice = current_user.cart.where(:state => 1).first.invoice
    end
    @ref = current_user.cart.where(:state => 1).first.invoice
    Nicepay.setRequestParam('referenceNo', @ref)
    Nicepay.setRequestParam('description','Payment of ' + @invoice) # Description
    Nicepay.setRequestParam('goodsNm', Nicepay.param('description')) # goodsNm = Description
    Cart.where(:state => 1, :user_id => current_user.id).each do |c|
    Nicepay.addCart((URI.parse(root_url) + Produk.find(c.produk_id).foto_produk1.url).to_s, "#{Produk.find(c.produk_id).nama_produk} + ongkir,fee", "Jumlah: #{c.jumlah}", c.subtotal)
    end
    @firstcart = Cart.where(:state => 1, :user_id => current_user.id).first.alamat_id
    @address = Alamat.find(@firstcart)
    Nicepay.setRequestParam('cartData', Nicepay.cartData)
    Nicepay.setRequestParam('amt', Nicepay.autoCountTotal)
    Nicepay.setRequestParam('currency', 'IDR')
    Nicepay.setRequestParam('billingNm', current_user.namalengkap)
    Nicepay.setRequestParam('billingPhone', @address.nomor_telepon)
    Nicepay.setRequestParam('billingEmail', current_user.email)
    Nicepay.setRequestParam('billingAddr', @address.alamat)
    Nicepay.setRequestParam('billingCity', @address.kota_sebagai)
    Nicepay.setRequestParam('billingState', @address.provinsi_sebagai)
    Nicepay.setRequestParam('billingPostCd', @address.kode_pos)
    Nicepay.setRequestParam('billingCountry', 'Indonesia')
    Nicepay.setRequestParam('deliveryNm', current_user.namalengkap)
    Nicepay.setRequestParam('deliveryPhone', @address.nomor_telepon)
    Nicepay.setRequestParam('deliveryEmail', current_user.email)
    Nicepay.setRequestParam('deliveryAddr', @address.alamat)
    Nicepay.setRequestParam('deliveryCity', @address.kota_sebagai)
    Nicepay.setRequestParam('deliveryState', @address.provinsi_sebagai)
    Nicepay.setRequestParam('deliveryPostCd', @address.kode_pos)
    Nicepay.setRequestParam('deliveryCountry', 'Indonesia')
    Nicepay.setRequestParam('userIP', Nicepay.userIp)
    Nicepay.setRequestParam('dbProcessUrl', Nicepay.dbProcessUrl)
    Nicepay.setRequestParam('callBackUrl', Nicepay.callBackUrl)
    Nicepay.setRequestParam('vat', 0)
    Nicepay.setRequestParam('fee', 0)
    Nicepay.setRequestParam('notaxAmt', 0)
    Nicepay.setRequestParam('vacctValidDt', Nicepay.vaExpiryDate(3)) # format: %Y%m%d
    Nicepay.setRequestParam('vacctValidTm', Nicepay.vaExpiryTime) # format: %H%M%S
    Nicepay.setRequestParam('merchantToken', Nicepay.merchantToken)
    response = requestVa.response
    if response["resultCd"].to_s == "0000"
        @van = response["bankVacctNo"].to_s
        @des = response["description"].to_s
        @ref = response["referenceNo"].to_s
        @txid = response["tXid"].to_s
        @amount = response["amount"].to_i
        amount = @amount
        van = @van

        @date =  Nicepay.vaExpiryDate(3)
        @time =  Nicepay.vaExpiryTime
        tanggal = @date
        time = @time
          if params[:bank] == "CENA"
            @bank = "BCA"
            elsif params[:bank] == "BNIN"
            @bank = "BNI"
            elsif params[:bank] == "BMRI"
            @bank = "MANDIRI"
            elsif params[:bank] == "HNBN"
            @bank = "HANA BANK"
            elsif params[:bank] == "IBBK"
            @bank = "MAYBANK"
            elsif params[:bank] == "BBBA"
            @bank = "PERMATA"
            else
            @bank = "TIDAK TERDAFTAR"
          end
          bank = @bank
          subject = Homeitem.find(20).text2
          countcart = Cart.where(:user_id => current_user.id, :state => 1).count
          redirect_to "/bank/?van=#{@van}&bank=#{@bank}&amount=#{@amount}&date=#{@date}&time=#{@time}&txid=#{@txid}"
          Cart.where(:user_id => current_user.id, :state => 1).update_all(:txid => @txid)
          Notifikasi.pembayaranva_email(countcart, van, amount, tanggal, time, bank, current_user, subject).deliver_later

    else response["resultCd"].to_s
        @status =  "\nOops! Virtual Account failed to generate! We have recorded the event. \nPlease try again later.\n\n"
        @code =  response["resultCd"]
        @msg =  response["resultMsg"]
    end
    Nicepay.flushParam
  end

  def cc
    Nicepay.iMid=('IONPAYTEST')
    Nicepay.merchantKey=('33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==')
    Nicepay.dbProcessUrl=("#{URI.parse(root_url)}/record")
    Nicepay.callBackUrl=("#{URI.parse(root_url)}/waiting")
    chargeCard  = Nicepay::Api::ChargeCard.new(Nicepay.requestParam)
    Nicepay.setRequestParam('iMid', Nicepay.iMid)
    Nicepay.setRequestParam('payMethod', '01')
    Nicepay.setRequestParam('instmntMon', '1')
    Nicepay.setRequestParam('instmntType', '1')
    if current_user.cart.where(:state => 1).count > 1
    @invoice = current_user.cart.where(:state => 1).first.invoice + " - " + current_user.cart.where(:state => 1).last.invoice
    else
    @invoice = current_user.cart.where(:state => 1).first.invoice
    end

    @ref = current_user.cart.where(:state => 1).first.invoice
    Nicepay.setRequestParam('referenceNo', @ref)
    Nicepay.setRequestParam('description','Payment of ' + @invoice) # Description
    Nicepay.setRequestParam('goodsNm', Nicepay.param('description')) # goodsNm = Description
    Cart.where(:state => 1, :user_id => current_user.id).each do |c|
    Nicepay.addCart((URI.parse(root_url) + Produk.find(c.produk_id).foto_produk1.url).to_s, "#{Produk.find(c.produk_id).nama_produk} + ongkir,fee", "Jumlah: #{c.jumlah}", c.subtotal)
    end
    @firstcart = Cart.where(:state => 1, :user_id => current_user.id).first.alamat_id
    @address = Alamat.find(@firstcart)
    Nicepay.setRequestParam('cartData', Nicepay.cartData)
    Nicepay.setRequestParam('amt', Nicepay.autoCountTotal)
    Nicepay.setRequestParam('currency', 'IDR')
    Nicepay.setRequestParam('billingNm', current_user.namalengkap)
    Nicepay.setRequestParam('billingPhone', @address.nomor_telepon)
    Nicepay.setRequestParam('billingEmail', current_user.email)
    Nicepay.setRequestParam('billingAddr', @address.alamat)
    Nicepay.setRequestParam('billingCity', @address.kota_sebagai)
    Nicepay.setRequestParam('billingState', @address.provinsi_sebagai)
    Nicepay.setRequestParam('billingPostCd', @address.kode_pos)
    Nicepay.setRequestParam('billingCountry', 'Indonesia')
    Nicepay.setRequestParam('deliveryNm', current_user.namalengkap)
    Nicepay.setRequestParam('deliveryPhone', @address.nomor_telepon)
    Nicepay.setRequestParam('deliveryEmail', current_user.email)
    Nicepay.setRequestParam('deliveryAddr', @address.alamat)
    Nicepay.setRequestParam('deliveryCity', @address.kota_sebagai)
    Nicepay.setRequestParam('deliveryState', @address.provinsi_sebagai)
    Nicepay.setRequestParam('deliveryPostCd', @address.kode_pos)
    Nicepay.setRequestParam('deliveryCountry', 'Indonesia')
    Nicepay.setRequestParam('userIP', Nicepay.userIp)
    Nicepay.setRequestParam('dbProcessUrl', Nicepay.dbProcessUrl)
    Nicepay.setRequestParam('callBackUrl', Nicepay.callBackUrl)
    Nicepay.setRequestParam('vat', 0)
    Nicepay.setRequestParam('fee', 0)
    Nicepay.setRequestParam('notaxAmt', 0)
    Nicepay.setRequestParam('merchantToken', Nicepay.merchantToken)
    response = chargeCard.response
    if response["resultCd"].to_s == "0000" && response["tXid"]
        @txid = response["tXid"].to_s
        Cart.where(:user_id => current_user.id, :state => 1).update_all(:txid => @txid)
        if Cart.where(:user_id => current_user.id, :state => 1).last.txid.present?
        redirect_to response["requestURL"].to_s + "?tXid=" + response["tXid"].to_s
        end
    else
        @status = "\nOops! Payment Page failed to generate! We have recorded the event. \nPlease try again later.\n\n"
        @code = response["resultCd"]
        @msg = response["resultMsg"]
    end


    # Flush request parameter
    Nicepay.flushParam
  end

  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:get, :post)
    end
end
