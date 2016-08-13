class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]


  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
    @subcategories = Subcategory.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @itemvalue = 15
    @min = 0
    @max = 1000000000
    @maxvalue = "-"
    @sort = "Produk Terbaru"
    if params[:sort]
      @itemvalue = params[:item]
      @min = params[:min]
      @max = params[:max]
      if params[:max] == "1000000000"
        @max = params[:max]
        @maxvalue = "-"
        else
        @maxvalue = params[:max]
      end
      @hargaselect = "max=" + @max + "&min=" + @min
      if params[:sort] == "1"
        @sort = "Produk Terbaru"
        @sortselect = 1
        @sortvalue = "created_at desc"
        elsif params[:sort] == "2"
        @sort = "Produk Terpopuler"
        @sortselect = 2
        @sortvalue = "bought asc"
        elsif params[:sort] == "3"
        @sort = "Diskon Terbesar"
        @sortselect = 3
        @sortvalue = "diskon desc"
        elsif params[:sort] == "4"
        @sort = "Rating Tertinggi"
        @sortselect = 4
        @sortvalue = "rating desc"
        else
        @sort = "Random"
        @sortselect = 5
        @sortvalue = "created_at desc"
      end
    end
    if params[:sort]
    @cat = Produk.where("harga_beli > ? AND harga_beli < ? AND category_id = ?", params[:min], params[:max], params[:id]).order(@sortvalue).paginate(:page => params[:page], :per_page => params[:item])
      else
      @cat = Produk.where("category_id = ?", params[:id]).order("created_at desc").paginate(:page => params[:page], :per_page => 15)
    end
    @categories = Category.all
    @category_id = Category.find(params[:id]).id
    @subcategory = Subcategory.where(category_id: @category_id)
  end

  def filter
    @cat = Produk.where("harga_beli > ? AND harga_beli < ?", params[:min], params[:max]).order(params[:sort]).paginate(:page => params[:page], :per_page => 15)
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to :back, notice: 'Kategori telah dibuat' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to :back, notice: 'Kategori diperbarui.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Kategori dihapus' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:kategori, :deskripsi, :slide1, :slide2, :slide3, :remove_slide1, :remove_slide2, :remove_slide3, :image)
    end

end
