class AddNamaToNewsletter < ActiveRecord::Migration
  def change
    add_column :newsletters, :nama, :string
    add_column :newsletters, :telepon, :string
  end
end
