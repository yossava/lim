class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  def konfirmasi
    Nicepay.iMid=('IONPAYTEST')
    Nicepay.merchantKey=('33F49GnCMS1mFYlGXisbUDzVf2ATWCl9k3R++d5hDd3Frmuos/XLx8XhXpe+LDYAbpGKZYSwtlyyLOtS/8aD7A==')
    Nicepay.dbProcessUrl=("#{URI.parse(root_url)}/record")
    Nicepay.callBackUrl=("#{URI.parse(root_url)}/update")
    checkStatus = Nicepay::Api::CheckStatus.new(Nicepay.requestParam)
    Nicepay.setRequestParam('iMid', Nicepay.iMid)
    Nicepay.setRequestParam('referenceNo', Cart.where(:txid => params[:txid]).first.invoice)
    @currentcart = Cart.where(:txid => params[:txid])
    @subtotal = []
    @currentcart.each do |c|
    @subtotal << c.subtotal
    end
    @subtotal = @subtotal.sum.to_s
    Nicepay.setRequestParam('amt', @subtotal)
    Nicepay.setRequestParam('tXid', params[:txid])
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
        Cart.where(:txid => params[:txid]).update_all(:state => 3)
        redirect_to :back, notice: "Pembayaran #{params[:txid]} TELAH diterima!"
        mycart = Cart.find(params[:id])
        status = "Telah Dikonfirmasi Buyer"
        Notifikasi.sample_email(current_user, mycart, status).deliver_later
        else
        redirect_to :back, notice: "Pembayaran #{params[:txid]} BELUM diterima!"
      end
        Nicepay.flushParam


  end

  def terima_pesanan
    if Cart.find(params[:id]).voucher == true
      Cart.find(params[:id]).update(:state => 6)
      else
      Cart.find(params[:id]).update(:state => 7)
    end
    redirect_to :back
    mycart = Cart.find(params[:id])
    status = "Telah Diproses Seller"
    subject = Homeitem.find(24).text2
    subject2 = Homeitem.find(24).text4
    Notifikasi.terima_pesanan(mycart, subject, subject2).deliver_later
  end
  def tolak_pesanan
    Cart.find(params[:id]).update(:state => 8)
    redirect_to :back
    mycart = Cart.find(params[:id])
    status = "Tidak Dapat Diproses oleh Seller"
    subject = Homeitem.find(23).text2
    subject2 = Homeitem.find(23).text4
    Notifikasi.pesanan_ditolak(mycart, subject, subject2).deliver_later
  end
  def kirim_pesanan
    Cart.find(params[:id]).update(:state => 4, :resi => params[:resi])
    redirect_to :back
    mycart = Cart.find(params[:id])
    status = "Telah Dikirim oleh Seller dengan resi: #{params[:resi]}"
    subject = Homeitem.find(25).text2
    subject2 = Homeitem.find(25).text4
    Notifikasi.pesanan_dikirim(mycart, subject, subject2).deliver_later
  end
  def pesanan_sampai
    Cart.find(params[:id]).update(:state => 5)
    redirect_to :back
    mycart = Cart.find(params[:id])
    status = "Pesanan dengan resi #{Cart.find(params[:id]).resi}, telah ditandai sebagai SAMPAI"
    subject = Homeitem.find(26).text2
    subject2 = Homeitem.find(26).text4
    Notifikasi.pesanan_diterima(mycart, subject, subject2).deliver_later
  end
  def checkout
    Cart.where(:user_id => current_user.id, :state=> 1).update_all(:state => 3)
    redirect_to '/payment'
  end
  def usevoucher
    Cart.find(params[:id]).update(:used => true)
    redirect_to '/evoucher'
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)
    @cart.user = current_user
    @cart.state = 1
    if Produk.find(params['cart']['produk_id']).category_id == "14"
    @cart.voucher = true
    @cart.subtotal = (params['cart']['harga'].to_i * params['cart']['jumlah'].to_i)
    end

    respond_to do |format|
      if @cart.save
        format.html { redirect_to :back, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to :back, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.require(:cart).permit(:toko_id, :user_id, :produk_id, :invoice, :catatan, :jumlah, :subtotal, :total, :metode_pembayaran, :alamat_id, :kurir, :berat, :ongkir, :seller_id, :state, :resi, :txid, :expired, :fee, :harga, :voucher)
    end
end
