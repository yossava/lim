class AddHargaToCart < ActiveRecord::Migration
  def change
    add_column :carts, :harga, :integer
  end
end
