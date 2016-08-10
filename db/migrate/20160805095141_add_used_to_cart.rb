class AddUsedToCart < ActiveRecord::Migration
  def change
    add_column :carts, :used, :boolean, default: false
  end
end
