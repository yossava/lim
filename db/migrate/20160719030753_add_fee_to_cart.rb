class AddFeeToCart < ActiveRecord::Migration
  def change
    add_column :carts, :fee, :decimal
  end
end
