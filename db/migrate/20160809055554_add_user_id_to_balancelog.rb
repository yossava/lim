class AddUserIdToBalancelog < ActiveRecord::Migration
  def change
    add_column :balancelogs, :user_id, :integer
  end
end
