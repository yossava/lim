class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.all
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new

  end

  # GET /feedbacks/1/edit
  def edit
  end

  def updaterating
    ratings = 0
      @feed =  Feedback.where(:produk_id => params[:produk_id])
      @feed.each do |f|
        ratings += f.rating
      end
      Produk.find(params[:produk_id]).update(:rating => ratings / @feed.count)
      redirect_to "/konfirmasi-penerimaan"
  end
  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user_id = current_user.id
    @donecart = Cart.find(params[:cart_id])
    @donecart.update(:state => 6)
    if @donecart.state == 6
      @usersaldo =  User.find(@donecart.seller_id).saldo
      @saldo = @donecart.subtotal
      User.find(@donecart.seller_id).update(:saldo => @saldo + @usersaldo)
      balance = Balancelog.new(cart_id: @donecart.id, nominal: @saldo, user_id: @donecart.seller_id, saldo: @saldo + @usersaldo, keterangan: "Transaksi penjualan Berhasil")
      balance.save!
    end
    mycart = @donecart
    status = "Telah Diterima Buyer, Transaksi selesai"
    subject = Homeitem.find(27).text2
    subject2 = Homeitem.find(27).text4
    Notifikasi.transaksi_selesai(mycart, subject, subject2).deliver_later

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to "/updaterating/#{params[:produk_id]}", notice: 'Feedback was successfully created.' }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: 'Feedback was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:user_id, :toko_id, :produk_id, :cart_id, :rating, :feed)
    end
end
