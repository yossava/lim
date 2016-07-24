class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :produks
  has_many :tokos
  has_many :alamats

  def self.search(sellersearch)
      sellersearch = sellersearch.downcase
      where("lower(invoice) LIKE :search OR lower(txid) LIKE :search", search: "%#{sellersearch}%")
   end
end
