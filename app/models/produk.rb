class Produk < ActiveRecord::Base
  is_impressionable
  before_create :alter_my_data
  before_update :alter_my_data
  before_create :hitung_diskon
  before_update :hitung_diskon
  mount_uploader :foto_produk1, ImageUploader
  mount_uploader :foto_produk2, ImageUploader
  mount_uploader :foto_produk3, ImageUploader
  mount_uploader :foto_produk4, ImageUploader
  mount_uploader :foto_produk5, ImageUploader
  mount_uploader :foto_produk6, ImageUploader
  belongs_to :user
  belongs_to :category
  belongs_to :subcategory
  belongs_to :subsubcategory
  belongs_to :toko
  belongs_to :cart
  has_many :favorite_produks
  has_many :feedbacks
  has_many :favorited_by, through: :favorite_produks, source: :user
  before_create :alter_my_data

    def self.search(search)
      search = search.downcase
      where("lower(deskripsi_lengkap) LIKE :search OR lower(nama_produk) LIKE :search", search: "%#{search}%")
    end
    def self.mysearch(search)
      search = search.downcase
      where("lower(deskripsi_lengkap) LIKE :search OR lower(nama_produk) LIKE :search", search: "%#{search}%")
    end

    def alter_my_data
        if self.harga_diskon.nil?
          self.harga_beli = self.harga
        elsif self.harga_diskon < 1
          self.harga_beli = self.harga
        elsif self.harga == self.harga_diskon
          self.harga_beli = self.harga
        elsif self.harga > self.harga_diskon
          self.harga_beli = self.harga_diskon
        else
          self.harga_beli = self.harga
        end
    end

    def hitung_diskon
      if self.harga_diskon != nil && self.harga_diskon > 0 && self.harga_diskon <  self.harga
        self.diskon = (self.harga - self.harga_diskon) / self.harga * 100
        else
        self.diskon = nil
        self.harga_diskon = nil
      end
    end
    extend FriendlyId
    friendly_id :nama_produk, use: :slugged
end
