class AddPenarikanToBalancelog < ActiveRecord::Migration
  def change
    add_column :balancelogs, :penarikan, :integer
    add_column :balancelogs, :rekening_id, :integer
  end
end
