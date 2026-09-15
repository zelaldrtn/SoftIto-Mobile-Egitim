class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);

  double kargoUcretiHesapla() {
    return 29.90;
  }
}

class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "DIJITAL");

  @override
  double kargoUcretiHesapla() {
        return 0.0; //hata gondermek yerine 0tl dondurebilriz.
    }
}


//Eski siskin arayuzu parcalara bolduk.

//Veritabani islemleri icin
abstract class IVeritabaniServisi{
    void kaydet(String sql);
}

//Mail bildirimleri icin
abstract class IMailServisi{
    void mailAt(String to, String body);
}

//SMS bildirimleri icin
abstract class ISmsServisi{
    void smsYolla(String gsm, String text);
}

//Bu kisimda da sadece kendi sozlesmelerine implement ettik.
class SqliteVeritabani implements IVeritabaniServisi {
    @override
    void kaydet(String sql) {
        print("DB calistirildi: " + sql);
  }
}

class SmtpMailServisi implements IMailServisi {
    @override
    void mailAt(String to, String body) {
        print("SMTP Mail gonderildi: " + to);
  }
}

class NetgsmSmsServisi implements ISmsServisi{
    @override
    void smsYolla(String gsm, String text) {
        print("SMS iletildi: " + gsm);
  }
}

abstract class OdemeYontemi {
  void ode(double tutar);
}

class KrediKartiOdeme implements OdemeYontemi {
  @override
  void ode(double tutar) => print("$tutar TL Kredi kartindan POS ile cekildi.");
}

class HavaleOdeme implements OdemeYontemi {
  @override
  void ode(double tutar) => print("$tutar TL Havale kontrol edildi.");
}

class KapidaOdeme implements OdemeYontemi {
  @override
  void ode(double tutar) => print("$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).");
}

class KriptoOdeme implements OdemeYontemi {
  @override
  void ode(double tutar) => print("$tutar TL USDT transferi onaylandi.");
}

//servisleri icerde olsuturmak yerine abstract arayuzlerinden aliyoruz.
class SiparisYoneticisi {
  final IVeritabaniServisi db;
  final IMailServisi mailci;
  final ISmsServisi smsci;

  SiparisYoneticisi({required this.db,required this.mailci,required this.smsci});

  void siparisKaydet(String orderId, double tutar) {
    db.kaydet("INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }

  void odemeYap(OdemeYontemi odemeYontemi, double tutar){
    odemeYontemi.ode(tutar);
  }

  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fis basildi: $adres");
  }

  @override
  void mailGonder(String email, String mesaj) {
    mailci.mailAt(email, mesaj);
  }

  @override
  void smsGonder(String tel, String mesaj) {
    smsci.smsYolla(tel, mesaj);
  }

  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF cikarildi: $orderId");
  }

  void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      OdemeYontemi odemeYontemi,
      String musteriAdi,
      String email,
      String tel,
      String adres,
      String kuponKodu) {
    
    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return;
      }
      toplam += sepet[i].fiyat;
      toplam += sepet[i].kargoUcretiHesapla();
      sepet[i].stok--;
    }

    if (kuponKodu == "INDIRIM10") {
      toplam = toplam * 0.90;
    } else if (kuponKodu == "YAZ20") {
      toplam = toplam * 0.80;
    } else if (kuponKodu == "SEPETTE50") {
      toplam = toplam - 50;
    }

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    odemeYap(odemeTipi, sonTutar);
    siparisKaydet(orderId, sonTutar);
    faturaYazdir(orderId);
    mailGonder(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL");
    smsGonder(tel, "Siparisiniz onaylandi: $orderId");
    kargoGonder(orderId, adres);
  }
}

void main() {
  var siparisci = SiparisYoneticisi(
    db: SqliteVeritabani(),
    mailci : SmtpMailServisi(),
    smsci: NetgsmSmsServisi()
  );

  var urun1 = Urun("1", "Kablosuz Mouse", 450.0, 5, "FIZIKSEL");
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    KrediKartiOdeme(),
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    "INDIRIM10",
  );
}