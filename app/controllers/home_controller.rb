class HomeController < ApplicationController
  before_filter :authenticate_user!, :only => [:profil]
  before_action :produk
  require 'rest_client'
  require 'net/http'

  def cronjobs
    Cart.where(:state => 3).each do |c|
      if (c.created_at + 4.days - Time.now).to_i/86400 < 1
        Cart.find(c.id).update(:expired => true)
        status = "Pesanan telah dibatalkan otomatis"
        mycart = c
        subject = Homeitem.find(28).text2
        subject2 = Homeitem.find(28).text4
        Notifikasi.batal_otomatis(mycart, subject, subject2).deliver_later
      end
    end
    Cart.where(:state => 2).each do |c|
      if (c.created_at + 3.days - Time.now).to_i/86400 < 1
        Cart.find(c.id).update(:expired => true)
        status = "Pesanan telah dibatalkan otomatis"
        mycart = c
        Notifikasi.sample_email(current_user, mycart, status).deliver_later
      end
    end
  end

  def expired
    Cart.find(params[:id]).update(:expired => true)
    redirect_to :back
  end
  def saldo
    if current_user.saldo.present? && current_user.saldo > -1
      @saldokotor = []
      Cart.where("state IN (?) AND seller_id = ?", [2,3,4,5,7], current_user.id).each do |c|
        @saldokotor << c.subtotal
      end
      @saldokotor = @saldokotor.sum + current_user.saldo
    end
    @balancelog = Balancelog.where(:user_id => current_user.id).order("updated_at desc").paginate(:page => params[:page], :per_page => 15)
  end

  def display
      respond_to do |format|
      format.js
      end
  end
  def ongkir
    if params[:kota]
    subs = RestClient.get 'http://pro.rajaongkir.com/api/subdistrict', {:params => {:city => params[:kota], :key => '45c5c245f49664fcd38a86f3c24f7763'}}
    @kecamatan = JSON.parse subs
    @kec = @kecamatan['rajaongkir']['results']
    end
    cities = RestClient.get 'http://pro.rajaongkir.com/api/city', {:params => {:province => params[:provinsi], :key => '45c5c245f49664fcd38a86f3c24f7763'}}
    provinces = RestClient.get 'http://pro.rajaongkir.com/api/province', {:params => {:key => '45c5c245f49664fcd38a86f3c24f7763'}}
    @province = JSON.parse provinces
    @city = JSON.parse cities
    @pro = @province['rajaongkir']['results']
    @cit = @city['rajaongkir']['results']
  end
  def index
    @newsletter = Newsletter.new
    @pro = Produk.order("RANDOM()").limit(20)
    @pro2 = Produk.all.sample(10)
    @pro3 = Produk.all.sample(4)
    @pro4 = Produk.where(:att => 1)
  end
  def profil
  end
  def konfirmasi_pengiriman
    if params[:sellersearch]
      @strolies = Cart.where("seller_id = ? AND state = ?", current_user.id, 7).search(params[:sellersearch]).paginate(:page => params[:page], :per_page => 10)
    end
  end
  def daftar_transaksi
    if params[:sellersearch]
      if params[:tglawal] != ""
      @tglawal = Time.strptime(params[:tglawal],"%m/%d/%Y")
        else
      @tglawal = Time.strptime("01/01/2015","%m/%d/%Y")
      end
      if params[:tglakhir] != ""
      @tglakhir = Time.strptime(params[:tglakhir],"%m/%d/%Y")
        else
      @tglakhir = Date.current
      end
      @trolies = Cart.where("user_id = ? AND created_at > ? AND created_at < ?", current_user.id, @tglawal, @tglakhir).search(params[:sellersearch]).paginate(:page => params[:page], :per_page => 10)
    end
    if params[:status] == "Menunggu Konfirmasi"
      @trolies = Cart.where(:user_id => current_user.id, :state => 2).paginate(:page => params[:page], :per_page => 10)
      elsif params[:status] == "Dalam Diproses"
       @trolies = Cart.where(:user_id => current_user.id, :state => 3).paginate(:page => params[:page], :per_page => 10)
      elsif params[:status] == "Sudah Dikirim"
       @trolies = Cart.where(:user_id => current_user.id, :state => 4).paginate(:page => params[:page], :per_page => 10)
      elsif params[:status] == "Transaksi Selesai"
       @trolies = Cart.where(:user_id => current_user.id, :state => [5,6]).paginate(:page => params[:page], :per_page => 10)
      elsif params[:status] == "Transaksi Ditolak"
       @trolies = Cart.where(:user_id => current_user.id, :state => 8).paginate(:page => params[:page], :per_page => 10)
    end
  end
  def pesanan_baru
    if params[:batal] == "Besok"
      @batal = Date.current - 2.days
      elsif params[:batal] == "2 Hari Lagi"
      @batal = Date.current - 1.days
      elsif params[:batal] == "3 Hari Lagi"
      @batal = Date.current
      else
      @batal = Date.current - 20.days
    end
    if params[:sellersearch]
      @trolies = Cart.where("user_id = ? AND created_at > ? AND state = ?", current_user.id, @batal, 3).search(params[:sellersearch]).paginate(:page => params[:page], :per_page => 10)
    end
  end
  def daftar_penjualan
    if params[:sellersearch]
      if params[:tglawal] != ""
      @tglawal = Time.strptime(params[:tglawal],"%m/%d/%Y")
        else
      @tglawal = Time.strptime("01/01/2015","%m/%d/%Y")
      end
      if params[:tglakhir] != ""
      @tglakhir = Time.strptime(params[:tglakhir],"%m/%d/%Y")
        else
      @tglakhir = Date.current
      end
      @strolies = Cart.where("seller_id = ? AND created_at > ? AND created_at < ?", current_user.id, @tglawal, @tglakhir).search(params[:sellersearch]).paginate(:page => params[:page], :per_page => 10)
    end
    if params[:status] == "Dalam Pengiriman"
      @strolies = Cart.where(:seller_id => current_user.id, :state => 4).paginate(:page => params[:page], :per_page => 10)
      elsif params[:status] == "Pesanan Baru"
       @strolies = Cart.where(:seller_id => current_user.id, :state => 3).paginate(:page => params[:page], :per_page => 10)
      elsif params[:status] == "Transaksi Selesai"
       @strolies = Cart.where(:seller_id => current_user.id, :state => 6).paginate(:page => params[:page], :per_page => 10)
      elsif params[:status] == "Pesanan Sampai"
       @strolies = Cart.where(:seller_id => current_user.id, :state => 5).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def edit
  end
  def evoucher
    if params[:id]
      @id = params[:id]
      @cart = Cart.find(@id)
      @produk = Produk.find(@cart.produk_id)
    end
    respond_to do |format|
      format.html {}
      format.js { render :file => "/home/evoucher.js.erb" }
    end
  end
  def finish
  end
  def bayar
    @currentcart = Cart.where(:user_id => current_user.id, :state => 1)
    @subtotal = []
    @currentcart.each do |c|
    @subtotal << c.subtotal
    end
  end


    private
    # Use callbacks to share common setup or constraints between actions.

    def produk
      @produks = Produk.all
      @couponcat = Category.find(14)
      @fashioncat = Category.find(7)
      @gadgetcat = Category.find(8)
      @beautycat = Category.find(9)
      @elektronikcat = Category.find(11)
      @sportcat = Category.find(12)
      @homecat = Category.find(13)
      @babycat = Category.find(10)
      @makanancat = Category.find(16)
      @fashionproduct = Produk.where(:category_id => @fashioncat).order('created_at DESC').take(10)
      @gadgetproduct = Produk.where(:category_id => @gadgetcat).order('created_at DESC').take(10)
      @beautyproduct = Produk.where(:category_id => @beautycat).order('created_at DESC').take(10)
      @electroproduct = Produk.where(:category_id => @elektronikcat).order('created_at DESC').take(10)
      @sportproduct = Produk.where(:category_id => @sportcat).order('created_at DESC').take(10)
      @homeproduct = Produk.where(:category_id => @homecat).order('created_at DESC').take(10)
      @babyproduct = Produk.where(:category_id => @babycat).order('created_at DESC').take(10)
      @foodproduct = Produk.where(:category_id => @makanancat).order('created_at DESC').take(10)
      @couponproduct = Produk.where(:category_id => @couponcat).order('created_at DESC').take(10)
    end
end
