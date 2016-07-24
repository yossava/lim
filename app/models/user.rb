class User < ActiveRecord::Base
  mount_uploader :profil_image, ImageUploader
  devise :registerable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :google_oauth2, :instagram]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pets,    dependent: :destroy
  has_many :alamats,    dependent: :destroy
  has_many :rekenings,    dependent: :destroy
  has_many :produks,    dependent: :destroy
  has_one :toko,    dependent: :destroy
  has_many :cart, dependent: :destroy
  has_many :favorite_produks
  has_many :favorites, through: :favorite_produks, source: :produk
  has_many :feedbacks

  def self.search(search)
      search = search.downcase
      where("lower(namalengkap) LIKE :search OR lower(email) LIKE :search", search: "%#{search}%")
  end
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      if auth.provider == "facebook" || auth.provider == "google_oauth2"
    user.email = auth.info.email
        else
        user.email = "#{auth.info.name.parameterize}@MasukanEmailAnda.com"
      end
    user.password = Devise.friendly_token[0,20]
    user.namalengkap = auth.info.name   # assuming the user model has a name
    user.remote_profil_image_url = auth.info.image.gsub('http://','https://') # assuming the user model has an image
    user.skip_confirmation!
    user.save!
  end
end

end
