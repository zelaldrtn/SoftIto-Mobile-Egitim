// IoT Cihaz Tipleri

enum CihazTipi { sensor, gateway, edgeServer, router }

//! enum: Önceden belirlediğimiz seçenekleri oluşturur.
//! CihazTipi diye bir şey olacak ve sadece bu 4 seçenekten biri olabilr

// IoT Cihaz Sınıfı

class IoTCihaz {
  //! final: Bu bilgiler nesne oluşturulduktan sonra değiştirilemez.
  final String seriNo;

  final String cihazAdi;

  //! Cihazın hangi tipte olduğunu tutuyoruz.
  //! Buraya sadece CihazTipi enumundaki değerlerden biri gelebilir.
  final CihazTipi tip;

  //! Cihazın CPU kullanım yüzdesini tutuyoruz.
  //! Örneğin 85.5 gibi ondalıklı değer gelebileceği için double.
  final double cpuYukYuzdesi;

  //! Cihazın kullandığı belleği MB olarak tutuyoruz.
  //! Tam sayı olduğu için int.
  final int bellekMb;

  //! Cihazın açık portlarını tutuyoruz.
  //! Set: Aynı değeri 2 kere tutmaz.
  final Set<String> acikPortlar;

  //! SSL sertifikası geçerli mi?
  //! true = geçerli, false = geçersiz.
  final bool sslSertifikasiGecerliMi;

  //! Ödevde cihazın açık veya kapalı olduğunu kontrol etmek için ekledik.
  final bool acikMi;

  // Constructor

  IoTCihaz({
    //! required: Bu bilgiler cihaz oluşturulurken verilmek zorunda.
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi,
    //! acikMi verilmezse otomatik olarak true kabul edilir.
    this.acikMi = true,
  });

  // Güvenlik Açığı Kontrolü

  bool get guvenlikAcigiVarMi =>
      //! SSL sertifikası geçerli değilse
      //! 23/TELNET portu açıksa
      //! cihazda güvenlik açığı var demektir.
      !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET");
}

// Özel Exception sınıfı

class CihazErisilemezException implements Exception {
  //! Hata olduğunda göstereceğimiz mesajı tutuyoruz.
  final String mesaj;
  CihazErisilemezException(this.mesaj);

  @override
  //! Exception ekrana yazdırıldığında mesajı göstermesini sağlıyor.
  String toString() => mesaj;
}

void main() {
  //! Dart programının başlangıç noktası.
  //! Program çalışınca ilk burası çalışır.

  print("IoT Ağ Yönetim Sistemi");

  // Cihazları oluşturuyoruz.

  //! List: Birden fazla IoTCihaz nesnesini aynı yerde tutuyoruz.
  //! Bu listede sadece IoTCihaz nesneleri olabilir.
  final List<IoTCihaz> cihazlar = [
    // 1. Cihaz

    IoTCihaz(
      seriNo: "SN-1001",
      cihazAdi: "Sicaklik Sensoru",
      //! Bu cihaz bir sensör.
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 45.5,
      bellekMb: 512,

      //! Set kullanıyoruz.
      //! Aynı port 2 kere yazılsa bile Set tekrarını tutmaz.
      acikPortlar: {"80/HTTP", "443/HTTPS"},

      //! SSL sertifikası geçerli.
      sslSertifikasiGecerliMi: true,
    ),

    // 2. Cihaz
    IoTCihaz(
      seriNo: "SN-1002",
      cihazAdi: "Ana Gateway",
      tip: CihazTipi.gateway,
      //! %85'in üzerinde olduğu için bu cihaz CPU açısından riskli olacak.
      cpuYukYuzdesi: 91.2,
      bellekMb: 1024,
      acikPortlar: {"443/HTTPS", "22/SSH"},
      sslSertifikasiGecerliMi: true,
    ),

    // 3. Cihaz
    IoTCihaz(
      seriNo: "SN-1003",
      cihazAdi: "Edge Sunucu",
      tip: CihazTipi.edgeServer,
      cpuYukYuzdesi: 72.0,
      bellekMb: 2048,
      //! 23/TELNET açık olduğu için güvenlik açığı var.
      acikPortlar: {"443/HTTPS", "23/TELNET"},
      sslSertifikasiGecerliMi: true,
    ),

    // 4. Cihaz
    IoTCihaz(
      seriNo: "SN-1004",
      cihazAdi: "Merkez Router",
      tip: CihazTipi.router,
      cpuYukYuzdesi: 65.4,
      bellekMb: 768,
      acikPortlar: {"22/SSH", "443/HTTPS"},
      //! SSL geçersiz olduğu için güvenlik açığı var.
      sslSertifikasiGecerliMi: false,
    ),

    // 5. Cihaz
    IoTCihaz(
      seriNo: "SN-1005",
      cihazAdi: "Hareket Sensoru",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 32.5,
      bellekMb: 256,
      acikPortlar: {"443/HTTPS"},
      sslSertifikasiGecerliMi: true,
    ),

    // 6. Cihaz
    IoTCihaz(
      seriNo: "SN-1006",
      cihazAdi: "Yedek Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 84.0,
      bellekMb: 1536,
      acikPortlar: {"443/HTTPS"},
      sslSertifikasiGecerliMi: true,
      //! Bu cihaz kapalı olarak oluşturuluyor.
      //! Daha sonra Exception kısmında bunu kontrol edeceğiz.
      acikMi: false,
    ),
  ];

  // Riskli cihazları bulma
  //! where(): Listedeki elemanları tek tek kontrol eder.
  //! Şartı sağlayanları seçer.
  final riskliCihazlar = cihazlar
      //! Cihazın güvenlik açığı varsa
      //! VEYA CPU kullanımı %85'ten büyükse
      //! o cihazı riskli cihazlar listesine al.
      .where((cihaz) => cihaz.guvenlikAcigiVarMi || cihaz.cpuYukYuzdesi > 85.0)
      //! where() sonucunu tekrar List haline getiriyoruz.
      .toList();

  //! Kaç tane riskli cihaz olduğunu ekrana yazdırıyoruz.
  print("\nRiskli Cihazlar (${riskliCihazlar.length} adet)");

  //! Riskli cihazların her birini tek tek ekrana yazdırıyoruz.
  riskliCihazlar.forEach(
    (cihaz) => print("* ${cihaz.cihazAdi} | CPU: %${cihaz.cpuYukYuzdesi}"),
  );

  // fold() ile toplam bellek

  //! Ağdaki bütün cihazların belleklerini topluyoruz.
  //! fold(): Listedeki bütün değerleri tek bir sonuç haline getirir.
  final int toplamBellek = cihazlar.fold(
    //! Toplamın başlangıç değeri 0.
    0,
    //! Listedeki her cihazın belleğini toplam değişkenine ekliyoruz.
    (toplam, cihaz) => toplam + cihaz.bellekMb,
  );

  //! Sonuçta bütün cihazların toplam MB değerini yazdırıyoruz.
  print("\nToplam Bellek: $toplamBellek MB");

  // Seri numarasına göre cihaz bulma
  //! SN-1003 seri numaralı cihazı bulmak için metodu çağırıyoruz.
  final sonuc = cihazBilgisiBul(cihazlar, "SN-1003");

  print("\nCihaz Bilgisi");
  //! Record içindeki cihaz adını alıyoruz.
  print("Ad: ${sonuc.cihazAdi}");
  //! Record içindeki cihaz tipini alıyoruz.
  print("Tip: ${sonuc.tip}");
  //! Record içindeki alarm durumunu alıyoruz.
  print("Alarm: ${sonuc.alarmDurumu}");

  // Switch Expression
  //! Bulduğumuz cihazın tipine göre izolasyon bölgesi belirliyoruz.
  print("\nİzolasyon Bölgesi: ${izolasyonBolgesiBelirle(sonuc.tip)}");
  // Exception ve try-catch
  try {
    //! SN-1006 cihazına erişmeye çalışıyoruz.
    cihazErisimKontrolu(cihazlar, "SN-1006");
  } on CihazErisilemezException catch (e) {
    //! Eğer CihazErisilemezException oluşursa burası çalışır.
    //! Hatayı yakalayıp ekrana yazdırıyoruz.
    print("\nHata yakalandı: $e");
  }
}

// Seri numarasına göre cihaz bilgisi bulma
//! Record döndürüyoruz.
//! Tek seferde 3 bilgi döndürüyoruz:
//! cihaz adı + cihaz tipi + alarm durumu
({String cihazAdi, CihazTipi tip, bool alarmDurumu}) cihazBilgisiBul(
  List<IoTCihaz> cihazlar,
  String seriNo,
) {
  //! where() ile seri numarası aradığımız seri numarasıyla aynı olan cihazı buluyoruz.
  //! Sonucu listeye çeviriyoruz.
  final cihaz = cihazlar.where((cihaz) => cihaz.seriNo == seriNo).toList();
  //! Eğer liste boşsa aradığımız seri numarası bulunamamış demektir.
  if (cihaz.isEmpty) {
    //! Kendi oluşturduğumuz Exception'ı fırlatıyoruz.
    throw CihazErisilemezException("Seri numarası bulunamadı: $seriNo");
  }

  //! Liste boş değilse ilk elemanı alıyoruz.
  final bulunanCihaz = cihaz.first;
  //! Bulduğumuz cihazla ilgili 3 bilgiyi Record olarak geri döndürüyoruz.
  return (
    cihazAdi: bulunanCihaz.cihazAdi,
    tip: bulunanCihaz.tip,
    //! Cihazın güvenlik açığı varsa
    //! VEYA CPU'su %85'ten büyükse alarm true olacak.
    alarmDurumu:
        bulunanCihaz.guvenlikAcigiVarMi || bulunanCihaz.cpuYukYuzdesi > 85.0,
  );
}

// Cihaz tipine göre izolasyon bölgesi belirleme
String izolasyonBolgesiBelirle(CihazTipi tip) {
  //! switch expression:
  //! Gelen tip hangisiyse karşısındaki değeri döndürür.
  //! Burada klasik switch-case yerine direkt değer döndüren switch kullanıyoruz.
  return switch (tip) {
    //! Cihaz sensörse ZONE-S döndür.
    CihazTipi.sensor => "ZONE-S",
    //! Cihaz gateway ise ZONE-G döndür.
    CihazTipi.gateway => "ZONE-G",
    //! Cihaz edge server ise ZONE-E döndür.
    CihazTipi.edgeServer => "ZONE-E",
    //! Cihaz router ise ZONE-R döndür.
    CihazTipi.router => "ZONE-R",
  };
}

// Cihazın erişilebilir olup olmadığını kontrol eden metot

void cihazErisimKontrolu(List<IoTCihaz> cihazlar, String seriNo) {
  //! Önce verilen seri numarasına sahip cihazı buluyoruz.
  final cihaz = cihazlar.where((cihaz) => cihaz.seriNo == seriNo).toList();
  //! Eğer cihaz bulunamadıysa hata fırlatıyoruz.
  if (cihaz.isEmpty) {
    throw CihazErisilemezException("Cihaz bulunamadı: $seriNo");
  }

  //! Cihazın acikMi değeri false ise cihaz kapalıdır.
  //! Bu durumda cihaza erişilemez.
  if (!cihaz.first.acikMi) {
    //! Kendi oluşturduğumuz Exception'ı fırlatıyoruz.
    throw CihazErisilemezException(
      "${cihaz.first.cihazAdi} cihazı erişilemiyor.",
    );
  }

  //! Buraya kadar geldiyse cihaz bulunmuştur ve açıktır.
  //! Yani erişim başarılı demektir.
  print("\n${cihaz.first.cihazAdi} cihazına erişim başarılı.");
}
