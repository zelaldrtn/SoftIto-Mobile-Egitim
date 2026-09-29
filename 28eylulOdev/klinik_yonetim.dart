//1.Enumları (derleme Zamanı güvenliği)
enum HizmetKategorisi { ciltYenileme, medikalEstetik, lazerEpilasyon, Lipo }
//! enum:önceden belirlediğimiz seçenekleri oluşturur yani hizmetKategroisi diye bişey olacak ve 
//! sadece şu 4 seçeneği olabilir. Sondaki Lipo ise Kategorisi
enum SeansDurumu { bekliyor, odadaIslemde, tamamlandi, iptalEdildi }

enum OdemeYontemi { krediKarti, havaleEft, nakit, klinikPaketKredisi }

//Danışan (müşteri) Modeli
class Danisan { //! danisan adında bir sınıf. danışan şablonu gibi düşünebiliriz
  final String id;  //! final:bidaha değiştrilemez
  final String adSoyad;
  final String telefon;
  final bool vipUyeMi;
  final List<String> alerjiler; //! boş olabilir ama null olamaz
  final String? ozelCiltNotu; //! Opsiyonel Null olabilir

  const Danisan({  //! Constructor: Danisan nesnesini olştrrken hangi bilgleri vereceğimizi belrleyen kısım
    required this.id, //! required: bu bilgi verilmek zorunda
    required this.adSoyad,
    required this.telefon,
    this.vipUyeMi = false,   //! zorunlu değil vip bilgisi verilmezse false döner
    this.alerjiler = const [],  //! alerji verilmezse değiştirilemez boş liste
    this.ozelCiltNotu,  //! null olabilir
  });

//! danışanın alerji listesi boş değilse hassas cildi vardır.
  bool get hassasCiltMi => alerjiler.isNotEmpty; 

  //Bilgi özet kartı
  String get bilgiOzeti {
    //! alerjiler listesi boşsa alerji yok varsa alerjileri ver
    //! şart ? doğruysa : yanlışsa
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"
        : "Alerjiler: ${alerjiler.join(', ')}";

    //! ?: soldaki değer null değilse onu kullan null ise sağdakini kullan 
    final String notBilgisi = ozelCiltNotu ?? "Özel medikal not girilmemiş";
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";
    //! Hazırladığımız sonucu gönder
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans (randevu) Modeli

class SeansKaydi {
  final String seansKodu;
  final Danisan danisan;  //! bu seansın hangi danısşana ait oldğn tutuyorz
  final HizmetKategorisi kategori;
  final String islemAdi;
  final double birimFiyat;
  final int seansSayisi;
  final double indirimOrani; // Örn 10.0
  final String? sorumluUzman;
  SeansDurumu durum;
  OdemeYontemi? odemeTipi;

  SeansKaydi({ //constructor
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi,
    required this.birimFiyat,
    this.seansSayisi = 1, //! seans sayısı verilmezse 1 kabul et
    this.indirimOrani = 0.0,
    this.sorumluUzman, //! verilmezse null
    this.durum = SeansDurumu.bekliyor, //! verilmezse otomatik bekliyor olsun
    this.odemeTipi,
  });

  double get brutTutar => birimFiyat * seansSayisi;

  double get indirimTutari {
    double toplamOran = indirimOrani; //! ilk normal indirimi aldık
    if (danisan.vipUyeMi) { //! eğer vipsr ekstra %10 indirim
      toplamOran += 10.0;
    }
    return brutTutar * (toplamOran / 100.0);  //! indirim tutarını hesaplıyor
  }
  //! Son Fiyatı hesaplıyorz
  double get netTutar => brutTutar - indirimTutari;
}

// Yönetim Servisi
class KlinikYoneticisi {
  final String subeAdi;
  //! Bu liste klinikteki bütün seansları tutacak. İçinde sadece SeansKAydi nesneleri olabilir.
  //! _: Bu değişken classın dışından doğrudan erişime kapalı
  //! []: başlangıçta liste boş
  final List<SeansKaydi> _seanslar = [];
  //! Map: Anahtar -> Değer | dan-101 -> Ahmet | string: anahtar tipi Danisan: değer tipi
  final Map<String, Danisan> _danisanRehberi = {};

//! yönetici olştrrken şube adını vermek zorundayız
  KlinikYoneticisi({required this.subeAdi});

  //Danışan kaydetme
  void danisanKaydet(Danisan danisan) { //!void : geriye değer döndürmyor
    _danisanRehberi[danisan.id] = danisan; //! Danisanı map e koyduk
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }

  void randevuOlustur(SeansKaydi seans) { //!seans alıyor
    _seanslar.add(seans); //! seansı listeye ekliyor
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }

  //! iki bilgi istiyor: seans kodu, ödeme yöntemi
  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    for (var seans in _seanslar) { //! listedeki her seansı teker teker gez
      if (seans.seansKodu == seansKodu) {  //! buldugmz senasın kodu aradığımızla aynı mı
        seans.durum = SeansDurumu.tamamlandi; //! eşleşirse durumunu tamamlandı yap
        seans.odemeTipi = odeme;  //!ödeme tipini de kaydediyorz
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
      }
    }
    print("Hata [$seansKodu] kodlu seans bulunamadı");
    return;
  }

//! seansı iptal etmek için seanskodu zorunlu iptal nedeni opsiyonel
  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurumu.iptalEdildi; //! seanskodu aradığımızla eşleşirse seansı iptal et
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
          //! ??: iptal nedeni varsa onu yaz yoksa gerekçe belirtlmedi yaz.
        );
        return;
      }
    }
  }

  // Finansal Rapor Metotları(fonksiyonel dart)
  //! Tamamlanan seanslardan toplam parayı hesapla
  double get toplamTahsilEdilenCiro => _seanslar
      .where((s) => s.durum == SeansDurumu.tamamlandi) //! listede sadece tamamlanmış seansları seç
      .fold(0.0, (toplam, s) => toplam + s.netTutar); //! seçtğm tüm değerleri tek bir sonuçta topla

//! henüz alınmamış ama beklenen parayı hesaplar
  double get beklenenPotansiyelCiro => _seanslar
      .where( //!durumu bekliyor veya islemde olanları seç
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // kategori bazlı seans sayıları
//! kategorşye göre kaç seans oldğnu hesaplar
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {};
    for (var kat in HizmetKategorisi.values) {  //! enumdaki bütün kategorileri gez
      dagilim[kat] = 0; //! her kategoriye başlangıçta 0 ver
    }
    for (var s in _seanslar) {
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1; //! o seans hangi kategorideyse o kategorinin sayısını 1 arttır
    }
    return dagilim;
  }

//!  SET: aynı elemanı tekrar tutmaz
  Set<String> gorevliUzmanKadrosu() {
    //! bütün seanslardan sadece sorumluUzman bilgisini al. sadece string olanları al (null olanlar olablr)
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet();
  }

  //Uzmansız kalan seanslar
  List<SeansKaydi> uzmansizSeanslariGetir() {
    //! bütün seanslardan sorumluUzman == null olanları seç ve listeye çevir.
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  void gunSonuRaporuYazdir() {
    print("Günlük Seans ve İşlem Çizelgesi");
    print("---------------------------------------");
    print(
      "${'Kod'.padRight((10))} | " //! yazının sağ tarafına boşluk ekle toplam uzunluğu 10 yap
      "${'Danışan'.padRight(16)} | "
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | ",
    );
    print("---------------------------------------");

    for (var s in _seanslar) { //! bütün seansları tek tek yazdır
      final String uzman = s.sorumluUzman ?? " Nöbetçi Bekliyor"; //! uzman varsa bull null ise nöbetçi bekliyor yaz
      final String durumRozet = switch (s.durum) { //!Durum neyse ona göre farklı yazı üretiyoruz
        SeansDurumu.tamamlandi => "Tamamlandı",
        SeansDurumu.odadaIslemde => "İşlemde",
        SeansDurumu.bekliyor => "Bekliyor",
        SeansDurumu.iptalEdildi => "İptal",
      };

      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        "$durumRozet",
      );
    }

    print("---------------------------------------");
    print("Finansal Özet:");
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );
    print(
      " * Bekleyen Potansiyen Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );
    print(" * Toplam Seans : ${_seanslar.length} Randevu");
    print("---------------------------------------");
    print("Aktif Uzmanlar");
    final uzmanlar = gorevliUzmanKadrosu();
    if (uzmanlar.isEmpty) {  //!uzmanlar boşsa bulunmadı yaz
      print("Kayıtlı Uzman Bulunamadı");
    } else {
      print(" ${uzmanlar.join(', ')}"); //! doluysa uzmanları yaz
    }
    final uzmansizlar = uzmansizSeanslariGetir();
    if (uzmansizlar.isNotEmpty) {
      print( //! kaç tane uzmansız oldgn yazdır
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );
      for (var u in uzmansizlar) {
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    print("---------------------------------------");
  }
}

void main() { //!dart programının başlangıç noktası program çaılışınca ilk burası çalılır
  print("Klinik yönetim sistemi başlatılıyor....");
  //! klinik yöneticisi sınıfından nesne olştrdk
  final yonetici = KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");

  //! danışanları oluşturalım
  final d1 = Danisan(
    id: "DAN-101",
    adSoyad: "Ahmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );
  final d2 = Danisan(
    id: "DAN-102",
    adSoyad: "Ahmet Yılan",
    telefon: "0555 555 55 55",
    vipUyeMi: false,
    alerjiler: [],
  );
  final d3 = Danisan(
    id: "DAN-103",
    adSoyad: "Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
  );
  final d4 = Danisan(
    id: "DAN-104",
    adSoyad: "Ahmet Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: [],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );

//! danisanlari rehbere kaydet
  yonetici.danisanKaydet(d1);
  yonetici.danisanKaydet(d2);
  yonetici.danisanKaydet(d3);
  yonetici.danisanKaydet(d4);

  print("Danışan güvenlik kontrolü");
  print(d1.bilgiOzeti);
  print(d2.bilgiOzeti);
  print("----------------------------------");

  //! randevular oluşturuluyor
  final seans1 = SeansKaydi(
    seansKodu: "SNS-2026-1",
    danisan: d1,
    kategori: HizmetKategorisi.Lipo,
    islemAdi: "Lipo gerisini bilmiyorum",
    birimFiyat: 6500.0,
    seansSayisi: 2,
    indirimOrani: 5.0,
    sorumluUzman: "Sümeyye Arab",
  );
  final seans2 = SeansKaydi(
    seansKodu: "SNS-2026-2",
    danisan: d2,
    kategori: HizmetKategorisi.ciltYenileme,
    islemAdi: "Siverex ile tyüz temizleme",
    birimFiyat: 2500.0,
    seansSayisi: 5,
    indirimOrani: 15.0,
    sorumluUzman: null,
  );
  final seans3 = SeansKaydi(
    seansKodu: "SNS-2026-3",
    danisan: d3,
    kategori: HizmetKategorisi.lazerEpilasyon,
    islemAdi: "Tüm Vücut",
    birimFiyat: 25000.0,
    seansSayisi: 15,
    indirimOrani: 0.0,
    sorumluUzman: "Tuba Aydın",
  );
  final seans4 = SeansKaydi(
    seansKodu: "SNS-2026-4",
    danisan: d4,
    kategori: HizmetKategorisi.medikalEstetik,
    islemAdi: "Burun Estetiği",
    birimFiyat: 1500.0,
    seansSayisi: 3,
    sorumluUzman: "Alaaddin Odabaşı",
  );
  //!Randevuları kaydediyorz
  yonetici.randevuOlustur(seans1);
  yonetici.randevuOlustur(seans2);
  yonetici.randevuOlustur(seans3);
  yonetici.randevuOlustur(seans4);
  print("Seanslar Gönderiliyor");

  //seans 1 başarıyla tamamlanıyor (kredi kartı ile ödeme);
  yonetici.seansiTamamla(
    seansKodu: "SNS-2026-1",
    odeme: OdemeYontemi.krediKarti,
  );
  //seans 2 başarıyla tamamlanıyor (nakit ödeme);
  yonetici.seansiTamamla(seansKodu: "SNS-2026-2", odeme: OdemeYontemi.nakit);
  //seans 4 iptal ediliyor
  yonetici.seansiIptalEt(
    "SNS-2026-4",
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
  );

  yonetici.gunSonuRaporuYazdir();
}