class AddVoucherToCart < ActiveRecord::Migration
  def change
    add_column :carts, :voucher, :boolean, default: false
  end
end
