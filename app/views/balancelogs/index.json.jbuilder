json.array!(@balancelogs) do |balancelog|
  json.extract! balancelog, :id, :cart_id, :nominal, :saldo, :keterangan
  json.url balancelog_url(balancelog, format: :json)
end
