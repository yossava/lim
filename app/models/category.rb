class Category < ActiveRecord::Base
    mount_uploader :slide1, ImageUploader
    mount_uploader :slide2, ImageUploader
    mount_uploader :slide3, ImageUploader
    has_and_belongs_to_many :subcategories
    has_many :produks

  def to_param
    "#{id}-#{kategori.parameterize}"
  end
end
