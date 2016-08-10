class AddRejectToBalancelog < ActiveRecord::Migration
  def change
    add_column :balancelogs, :reject, :boolean, default: false
  end
end
