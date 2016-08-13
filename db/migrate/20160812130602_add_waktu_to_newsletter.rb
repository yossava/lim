class AddWaktuToNewsletter < ActiveRecord::Migration
  def change
    add_column :newsletters, :waktu, :string
  end
end
