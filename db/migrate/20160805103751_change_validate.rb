class ChangeValidate < ActiveRecord::Migration
  def change
    rename_column :produks, :validate, :vouchervalid
  end
end
