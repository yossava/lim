class AddValidToProduk < ActiveRecord::Migration
  def change
    add_column :produks, :valid, :string
  end
end
