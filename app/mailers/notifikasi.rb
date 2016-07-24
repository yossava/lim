class Notifikasi < ApplicationMailer
  default from: "support@netvcc.co.id"

  def sample_email(current_user, mycart, status)
    @user = current_user
    @mycart = mycart
    @status = status
    mail(to: User.find(@mycart.user_id).email, subject: "Status Pemesanan #{@mycart.invoice} - #{@status} ")
  end
  def pesanan_ditolak(mycart, subject, subject2)
    @mycart = mycart
    @subject = subject
    @subject2 = subject2
    mail(to: User.find(@mycart.user_id).email, subject: "#{@subject}", template_name: "tolak_pesanan_buyer").deliver
    mail(to: User.find(@mycart.seller_id).email, subject: "#{@subject2}", template_name: "tolak_pesanan_seller").deliver
  end
  def pesanan_diterima(mycart, subject, subject2)
    @mycart = mycart
    @subject = subject
    @subject2 = subject2
    mail(to: User.find(@mycart.user_id).email, subject: "#{@subject}", template_name: "terima_pesanan_buyer").deliver
    mail(to: User.find(@mycart.seller_id).email, subject: "#{@subject2}", template_name: "terima_pesanan_seller").deliver
  end
  def pesanan_dikirim(mycart, subject, subject2)
    @mycart = mycart
    @subject = subject
    @subject2 = subject2
    mail(to: User.find(@mycart.user_id).email, subject: "#{@subject}", template_name: "pesanan_terkirim_buyer").deliver
    mail(to: User.find(@mycart.seller_id).email, subject: "#{@subject2}", template_name: "pesanan_terkirim_seller").deliver
  end
  def pesanan_diterima(mycart, subject, subject2)
    @mycart = mycart
    @subject = subject
    @subject2 = subject2
    mail(to: User.find(@mycart.user_id).email, subject: "#{@subject}", template_name: "pesanan_diterima_buyer").deliver
    mail(to: User.find(@mycart.seller_id).email, subject: "#{@subject2}", template_name: "pesanan_diterima_seller").deliver
  end
  def transaksi_selesai(mycart, subject, subject2)
    @mycart = mycart
    @subject = subject
    @subject2 = subject2
    mail(to: User.find(@mycart.user_id).email, subject: "#{@subject}", template_name: "transaksi_selesai_buyer").deliver
    mail(to: User.find(@mycart.seller_id).email, subject: "#{@subject2}", template_name: "transaksi_selesai_seller").deliver
  end
  def batal_otomatis(mycart, subject, subject2)
    @mycart = mycart
    @subject = subject
    @subject2 = subject2
    mail(to: User.find(@mycart.user_id).email, subject: "#{@subject}", template_name: "batal_otomatis_buyer").deliver
    mail(to: User.find(@mycart.seller_id).email, subject: "#{@subject2}", template_name: "batal_otomatis_seller").deliver
  end

  def checkout_email(current_user, status, countcart)
    @user = current_user
    @mycart = Cart.where(:user_id => current_user.id).order("id desc").limit(countcart)
    @status = status
    mail(to: User.find(@mycart.last.user_id).email, subject: "Status Pemesanan #{@mycart.last.invoice} - #{@status} ")
  end
  def pembayaran_berhasil(current_user, status, countcart, subject, subject2)
    @user = current_user
    @mycart = Cart.where(:user_id => current_user.id).order("id desc").limit(countcart)
    @status = status
    @subject = subject
    @subject2 = subject2
    mail(to: User.find(@mycart.last.user_id).email, subject: "#{@subject}", template_name: "pembayaran_berhasil").deliver
    @mycart.uniq.each do |c|
    mail(to: User.find(c.seller_id).email, subject: "#{@subject2}", template_name: "pembayaran_berhasil_seller").deliver
    end
  end
  def pembayaranva_email(countcart, van, amount, tanggal, time, bank, current_user, subject)
    @van = van
    @amount = amount
    @date = tanggal
    @time = time
    @bank = bank
    @subject = subject

    @mycart = Cart.where(:user_id => current_user.id).order("id desc").limit(countcart)
    mail(to: User.find(@mycart.last.user_id).email, subject: "#{@subject}")
  end
end
