// ürün kategorilerini numaralandırılmış liste (enum) olarak tanımlıyoruz
enum Kategori {
  hepsi,
  elektronik,
  taki,
  erkekGiyim,
  kadinGiyim,
}

// enum'a ek metot ve özellikler kazandıran extension
extension KategoriExtension on Kategori {
  // ekranda kullanıcıya gösterilecek Türkçe başlık
  String get gorunenAd {
    switch (this) {
      case Kategori.hepsi:
        return 'Tümü';
      case Kategori.elektronik:
        return 'Elektronik';
      case Kategori.taki:
        return 'Takı & Mücevher';
      case Kategori.erkekGiyim:
        return 'Erkek Giyim';
      case Kategori.kadinGiyim:
        return 'Kadın Giyim';
    }
  }

  // FakeStore API'den gelen İngilizce metni enum tipine dönüştürür
  static Kategori apiMetnindenUret(String apiMetni) {
    switch (apiMetni.toLowerCase().trim()) {
      case 'electronics':
        return Kategori.elektronik;
      case 'jewelery':
        return Kategori.taki;
      case "men's clothing":
        return Kategori.erkekGiyim;
      case "women's clothing":
        return Kategori.kadinGiyim;
      default:
        return Kategori.elektronik;
    }
  }
}

