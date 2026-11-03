// sabit ürün kategorilerini numaralandırılmış liste (enum) olarak tutuyoruz
enum Kategori{
    hepsi,
    elektronik,
    taki,
    erkekGiyim,
    kadinGiyim, 
}

// enum'a ek özellikler ve yardımcı metotlar kazandırmak için extension yazıyoruz
extension KategoriExtension on Kategori{
    // ekranda kullanıcıya gösterilecek Türkçe başlığı döndüren getter
    String get gorunenAd{
        switch(this){
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

    // API'den gelen İngilizce kategori metnini enum değerimize eşleştirir
    static Kategori apiMetindenUret(String apiMetni){
        // küçük harfe çevirip baştaki-sondaki boşlukları temizleyerek karşılaştırıyoruz
        switch (apiMetni.toLowerCase().trim()){
            case 'electronics':
                return Kategori.elektronik;
            case 'jewelery':
                return Kategori.taki;
            case "men's clothing":
                return Kategori.taki;
            case "women's clothing":
                return Kategori.kadinGiyim;
            default:
                return Kategori.elektronik;
        }
    }
}

