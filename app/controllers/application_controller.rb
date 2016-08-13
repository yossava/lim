class ApplicationController < ActionController::Base
  before_filter :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :tokosaya
  before_action :troli
  before_action :news
  before_filter :banned?
  after_filter :store_location
  require 'csv'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  def banned?
    if current_user.present? && current_user.block?
      sign_out current_user
      flash[:error] = "This account has been suspended...."
      root_path
    end
  end
  def news
    @newsletter = Newsletter.new
  end
  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
      if Rails.application.routes.recognize_path(request.referrer)[:controller] == "admins"
        "/admin/gate"
      else
        "/masuk"
    end
  end
  def after_sign_in_path_for(resource)
     if current_user.admin?
        "/admin"
      else
        request.env['omniauth.origin'] || session[:previous_url] || root_path
     end
  end
  def tokosaya
      if user_signed_in?
      if current_user.toko
      @toko = current_user.toko
      end
      end
  end
  def troli
    if user_signed_in? && current_user.cart
      @troli = current_user.cart.where(:state => 1)
      @troli2 = current_user.cart.where(:state => 2)
      @troli2live = current_user.cart.where(:state => 2, :expired => false)
      @troli3 = current_user.cart.where(:state => 3)
      @troli3live = current_user.cart.where(:state => 3, :expired => false)
      @troli4 = current_user.cart.where(:state => 4)
      @troli5 = current_user.cart.where(:state => 5)
      @troli6 = current_user.cart.where(:state => 6)
      @troli7 = current_user.cart.where(:state => 7)
      @troli7live = current_user.cart.where(:state => 7, :expired => false)
      @troli8 = current_user.cart.where(:state => 8)
      @trolies = current_user.cart.where(:state => [2,3,4,5,6,8]).paginate(:page => params[:page], :per_page => 10)
      @evoucher = current_user.cart.where("voucher = ? AND state > ?", true, 1)
    end
    if user_signed_in? && Cart.where(:seller_id => current_user.id).present?
      @stroli3 = Cart.where(:seller_id => current_user.id, :state => 3)
      @stroli3live = Cart.where(:seller_id => current_user.id, :state => 3, :expired => false) #sellertab count
      @stroli7 = Cart.where(:seller_id => current_user.id, :state => 7)
      @stroli6 = Cart.where(:seller_id => current_user.id, :state => 6)
      @stroli4 = Cart.where(:seller_id => current_user.id, :state => 4)
      @stroli5 = Cart.where(:seller_id => current_user.id, :state => 5)
      @strolies = Cart.where(:seller_id => current_user.id, :state => [3,4,5,6,7]).paginate(:page => params[:page], :per_page => 10)

    end
  end


  protected

  def configure_devise_permitted_parameters
    permitted_params = [:email, :password, :password_confirmation, :namalengkap, :nomor_handphone, :is_female, :date_of_birth, :profil_image, :remote_profil_image_url]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) {
        |u| u.permit(permitted_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) {
        |u| u.permit(permitted_params)
      }
    end
  end
end
