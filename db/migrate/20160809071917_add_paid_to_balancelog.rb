class AddPaidToBalancelog < ActiveRecord::Migration
  def change
    add_column :balancelogs, :paid, :boolean, default: false
  end
end
