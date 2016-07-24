class TokosController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :review]
  before_action :set_toko, only: [:show, :edit, :update, :destroy, :review]

  # GET /tokos
  # GET /tokos.json
  def category

    User.find(@toko.user_id).produks.each do |produk|
      @cat = produk.category_id
    end
  end
  def index
  end
  def review
    @review = @toko.feedbacks.paginate(:page => params[:page], :per_page => 10)
  end

  def kategori
  end
  def pengiriman
    if @toko
    @tokos = @toko
    else
    redirect_to '/toko/new'
    end
  end
  # GET /tokos/1
  # GET /tokos/1.json
  def show
    @mytoko = User.find(@toko.user_id).produks.paginate(:page => params[:page], :per_page => 12)
  end

  # GET /tokos/new
  def new
    @toko = Toko.new
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

  # GET /tokos/1/edit
  def edit
    subsx = RestClient.get 'http://pro.rajaongkir.com/api/subdistrict', {:params => {:id => @toko.kecamatan, :key => '45c5c245f49664fcd38a86f3c24f7763'}}
    @kecamatanx = JSON.parse subsx
    @kecx = @kecamatanx['rajaongkir']['results']['subdistrict_name']
    citiesx = RestClient.get 'http://pro.rajaongkir.com/api/city', {:params => {:id => @toko.kota, :key => '45c5c245f49664fcd38a86f3c24f7763'}}
    provincesx = RestClient.get 'http://pro.rajaongkir.com/api/province', {:params => {:id => @toko.provinsi, :key => '45c5c245f49664fcd38a86f3c24f7763'}}
    @provincex = JSON.parse provincesx
    @cityx = JSON.parse citiesx
    @prox = @provincex['rajaongkir']['results']['province']
    @citx = @cityx['rajaongkir']['results']['city_name']

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

  # POST /tokos
  # POST /tokos.json
  def create
    @toko = Toko.new(toko_params)
    @toko.user = current_user

    respond_to do |format|
      if @toko.save
        format.html { redirect_to '/finish', notice: 'Toko telah dibuat.' }
        format.json { render :show, status: :created, location: @toko }
      else
        format.html { render :new }
        format.json { render json: @toko.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tokos/1
  # PATCH/PUT /tokos/1.json
  def update
    respond_to do |format|
      if @toko.update(toko_params)
        format.html { redirect_to :back, notice: 'Toko telah diperbarui.' }
        format.json { render :show, status: :ok, location: @toko }
      else
        format.html { render :edit }
        format.json { render json: @toko.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tokos/1
  # DELETE /tokos/1.json
  def destroy
    @toko.destroy
    respond_to do |format|
      format.html { redirect_to tokos_url, notice: 'Toko telah dihapus.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_toko
      @toko = Toko.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def toko_params
      params.require(:toko).permit(:nama_toko, :provinsi, :kota, :kecamatan, :agen1, :agen2, :agen3, :agen4, :agen5, :agen6, :agen7, :slogan, :deskripsi, :alamat, :status, :tutup_sampai, :toko_image, :banner1, :banner2, :banner3, :user_id, :kode_pos, :catatan, :terima_pembayaran1, :terima_pembayaran2,:terima_pembayaran3, :kota_sebagai, :slug, :remove_toko_image)
    end
end
