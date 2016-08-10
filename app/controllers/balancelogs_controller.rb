class BalancelogsController < ApplicationController
  before_action :set_balancelog, only: [:show, :edit, :update, :destroy]

  # GET /balancelogs
  # GET /balancelogs.json
  def index
    @balancelogs = Balancelog.all
  end

  # GET /balancelogs/1
  # GET /balancelogs/1.json
  def show
  end

  # GET /balancelogs/new
  def new
    @balancelog = Balancelog.new
  end

  # GET /balancelogs/1/edit
  def edit
  end

  # POST /balancelogs
  # POST /balancelogs.json
  def create
    @balancelog = Balancelog.new(balancelog_params)

    respond_to do |format|
      if @balancelog.save
        format.html { redirect_to @balancelog, notice: 'Balancelog was successfully created.' }
        format.json { render :show, status: :created, location: @balancelog }
      else
        format.html { render :new }
        format.json { render json: @balancelog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /balancelogs/1
  # PATCH/PUT /balancelogs/1.json
  def update
    respond_to do |format|
      if @balancelog.update(balancelog_params)
        format.html { redirect_to @balancelog, notice: 'Balancelog was successfully updated.' }
        format.json { render :show, status: :ok, location: @balancelog }
      else
        format.html { render :edit }
        format.json { render json: @balancelog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /balancelogs/1
  # DELETE /balancelogs/1.json
  def destroy
    @balancelog.destroy
    respond_to do |format|
      format.html { redirect_to balancelogs_url, notice: 'Balancelog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_balancelog
      @balancelog = Balancelog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def balancelog_params
      params.require(:balancelog).permit(:cart_id, :nominal, :saldo, :keterangan, :user_id, :penarikan, :rekening_id, :paid, :reject)
    end
end
