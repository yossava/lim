Rails.application.routes.draw do
  resources :balancelogs
  resources :subsubcategories
  resources :financelogs
  resources :newsletters
  resources :transactions
  resources :homeitems
  resources :statics
  resources :feedbacks
  resources :statuses
  resources :carts
  resources :favorite_produks
  resources :subcategories
  resources :categories
  resources :produks, path: 'produk'
  resources :tokos, path: 'toko'
  resources :rekenings, path: 'rekening'
  resources :alamats, path: 'alamat'
  resources :pets



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  post '/penarikan' => 'transactions#penarikan'
  get '/saldo' => 'home#saldo'
  get '/usevoucher/:id' => 'carts#usevoucher'
  post '/evoucher' => 'home#evoucher'
  get '/evoucher' => 'home#evoucher'
  get '/promo' => 'home#promo'
  get '/admin/promoproduct' => 'admins#promoproduct'
  get '/updaterating/:produk_id' => "feedbacks#updaterating"
  get '/bank' => "transactions#bank"
  get '/va/:bank' => "transactions#va"
  get '/waiting' => "transactions#waiting"
  get '/update' => "transactions#updatetx"
  get '/record' => "transactions#record"
  post '/record' => "transactions#record"
  root 'home#index'
  get "/cek" => "transactions#cek"
  get "/va" => "transactions#va"
  get "/cc" => "transactions#cc"
  get "/hitungongkir" => "produks#hitungongkir"
  get "/display" => "home#display"
  get "/tentang" => "home#tentang"
  get "/expired/:id" => "home#expired"
  get "/karir" => "home#karir"
  get "/toko/:id/review" => "tokos#review"
  get "/alamat/new/:provinsi" => "alamats#new"
  get "/alamat/new/:provinsi/:kota" => "alamats#new"
  get "/toko/new/:provinsi" => "tokos#new"
  get "/toko/new/:provinsi/:kota" => "tokos#new"
  get "/alamat/edit/:id/:provinsi" => "alamats#edit"
  get "/alamat/edit/:id/:provinsi/:kota" => "alamats#edit"
  get "/toko/:id/edit/:provinsi" => "tokos#edit"
  get "/toko/:id/edit/:provinsi/:kota" => "tokos#edit"
  get "/email" => "home#email"
  get "/cari" => "produks#cari"
  get "/findmyproduct" => "produks#index"
  get "/checkout" => "carts#checkout"
  get "/konfirmasi_kirim/" => "carts#kirim_pesanan"
  get "/pengiriman-sampai/:id" => "carts#pesanan_sampai"
  get "/konfirmasi-transfer/:id" => "carts#konfirmasi"
  get "/terima-pesanan/:id" => "carts#terima_pesanan"
  get "/tolak-pesanan/:id" => "carts#tolak_pesanan"
  get "/diterima" => "carts#diterima"
  get "/konfirmasi-pembayaran" => "home#konfirmasi-pembayaran"
  get "/payment" => "home#payment"
  get "/konfirmasi_pengiriman" => "home#konfirmasi_pengiriman"
  get "/daftar_penjualan" => "home#daftar_penjualan"
  get "/pesanan_baru" => "home#pesanan_baru"
  get "/daftar_transaksi" => "home#daftar_transaksi"
  get "/konfirmasi-penerimaan" => "home#konfirmasi-penerimaan"
  get "/status-pemesanan" => "home#status-pemesanan"
  get "/berhasil" => "home#confirmed"
  get "/bayar" => "home#bayar"
  get "/wishlist" => "home#wishlist"
  get "/profil" => "home#profil"
  get "/finish" => "home#finish"
  get "/masuk" => "home#masuk"
  get "/konfirmasi" => "home#konfirmasi"
  get "/terms" => "home#terms"
  get "/kategori" => "tokos#kategori"
  get "/toko/:id/catatan" => "tokos#catatan"
  get "/pengiriman/:id" => "tokos#pengiriman"
  get "/produk/:id/unfav" => "favorite_produks#destroy"
  #get "/editalamat:id", to: "alamats#edit", as: 'alamat'

  #cronjobs
  get "/cronjobs" => "home#cronjobs"

  #AMDIN#ADMIN#ADMIN
  devise_scope :user do
    delete 'logout' => "devise/sessions#destroy"
    get 'edit' => "devise/registrations#edit"
  end
  get 'admin/email/:id' => "admins#email"
  get 'admin/email' => "admins#email"
  get 'admin/wd_request' => "admins#wd_request"
  post 'admin/wd_request' => "admins#wd_request"
  get 'admin/fee' => "admins#fee"
  get 'admin/general' => "admins#general"
  get 'admin/financelogs' => "admins#financelogs"
  get 'admin/newsletter' => "admins#newsletter"
  get 'admin/gate' => "admins#login"
  get 'admin/topproduct/:top/:id' => "admins#topproduct"
  get 'admin/topproduct' => "admins#topproduct"
  get 'admin/finance' => "admins#finance"
  get 'admin/finance/:id' => "admins#finance"
  get 'admin/beadmin/:id' => "admins#becomeadmin"
  get 'admin/general/:id' => "admins#becomegeneral"
  get 'admin/financeadmin/:id' => "admins#becomefinance"
  get 'admin/ungeneral/:id' => "admins#ungeneral"
  get 'admin/unfinance/:id' => "admins#unfinance"
  get 'admin/blockuser/:id' => "admins#blockuser"
  get 'admin/unblockuser/:id' => "admins#unblockuser"
  get 'admin/resendconfirmation/:id' => "admins#resendconfirmation"
  get 'admin/resetpassword/:id' => "admins#resetpassword"
  get 'admin/deladmin/:id' => "admins#deleteadmin"
  get 'admin/users' => "admins#users"
  get 'admin/edituser/:id' => "admins#users"
  post 'admin/edituser/:id' => "admins#users"
  get 'admin/homepage' => "admins#homepage"
  get 'admin/homepage/:id' => "admins#homepage"
  get 'admin/stores' => "admins#stores"
  get 'admin/stores/:id' => "admins#stores"
  get 'admin/products' => "admins#products"
  get 'admin/products/:id' => "admins#products"
  get 'admin/categories' => "admins#categories"
  get 'admin/categories/new' => "admins#newcategory"
  get 'admin/categories/:id' => "admins#categories"
  get 'admin/subcategories' => "admins#subcategories"
  get 'admin/subcategories/:id' => "admins#subcategories"
  get 'admin/subsubcategories' => "admins#subsubcategories"
  get 'admin/subsubcategories/:id' => "admins#subsubcategories"
  get 'admin/statics' => "admins#statics"
  get 'admin/statics/:id' => "admins#statics"
  get 'admin' => "admins#dashboard"

  match 'deleteuser/:id' => 'admins#destroyuser', :via => :delete, :as => :admin_destroy_user
  match 'deletestore/:id' => 'admins#destroystore', :via => :delete, :as => :admin_destroy_store
  match 'deleteproduct/:id' => 'admins#destroyproduct', :via => :delete, :as => :admin_destroy_product
  match 'deletecategory/:id' => 'admins#destroycategory', :via => :delete, :as => :admin_destroy_category
  match 'deletesubcategory/:id' => 'admins#destroysubcategory', :via => :delete, :as => :admin_destroy_subcategory
  match 'deletesubsubcategory/:id' => 'admins#destroysubsubcategory', :via => :delete, :as => :admin_destroy_subsubcategory
  match 'deletestatic/:id' => 'admins#destroystatic', :via => :delete, :as => :admin_destroy_static
  match 'deletehomeitem/:id' => 'admins#destroyhomeitem', :via => :delete, :as => :admin_destroy_homeitem
  match 'deletenewsletter/:id' => 'admins#destroynewsletter', :via => :delete, :as => :admin_destroy_newsletter



  devise_scope :user do
    get "/daftar" => "devise/registrations#new"
    get "/editprofil" => "user/registrations#edit"
  end



  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", registrations: 'users/registrations', :confirmations => "users/confirmations" }


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
