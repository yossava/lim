json.array!(@tokos) do |toko|
  json.extract! toko, :id, :nama_toko, :provinsi, :kota, :kecamatan, :agen1, :agen2, :agen3, :agen4, :agen5, :agen6, :agen7, :slogan, :deskripsi, :alamat, :status, :tutup_sampai, :gambar, :banner1, :banner2, :banner2
  json.url toko_url(toko, format: :json)
end
