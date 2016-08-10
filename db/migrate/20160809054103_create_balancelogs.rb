class CreateBalancelogs < ActiveRecord::Migration
  def change
    create_table :balancelogs do |t|
      t.integer :cart_id
      t.integer :nominal
      t.integer :saldo
      t.text :keterangan

      t.timestamps null: false
    end
  end
end
