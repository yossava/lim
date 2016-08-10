class ChangeValid < ActiveRecord::Migration
  def change
    rename_column :produks, :valid, :validate
  end
end
