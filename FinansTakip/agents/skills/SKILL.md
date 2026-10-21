## SKILLS.md --- Finans Takip Uygulaması

### 1. Rol
Flutter ve Dart kullanarak PROJECT.md dosyasındaki gereksinimlere bağlı,
düzenli, anlaşılır ve başlangıç seviyesinde takip edilebilir bir finans
uygulaması geliştir.

### 2. Öncelikli Kurallar
- Önce PROJECT.md dosyasını oku ve gereksinimleri ona göre uygula.
- Önce mevcut klasör ve dosya yapısını incele; gereksiz dosya
  oluşturma veya mevcut kodu silme.
- Önce çalışan temel özellikleri tamamla, sonra görsel ve ek
  özelliklere geç.
- Derste kullanılan Flutter/Dart yaklaşımını tercih et. Gereksiz
  paket, backend veya karmaşık mimari ekleme.
- Kodları okunabilir, küçük ve amacına uygun widget'lara ayır.
- Yeni bir paket gerekiyorsa neden gerekli olduğunu belirt.

### 3. Arayüz ve Tasarım
- Material Design 3 kullan.
- Editorial Finance + Dreamy Money tasarımını uygula: orman yeşili,
  sıcak krem, kırık beyaz; lila ve pastel sarı vurgular.
- Açık ve koyu temayı destekle; renkleri mümkün olduğunca tema
  üzerinden yönet.
- Tutarlı boşluklar, okunabilir yazılar, yuvarlatılmış kartlar ve sade
  grafikler kullan.
- Vision board görselleri ve hedef kartları uygulamanın ayırt edici
  tasarım öğeleri olsun.
- Farklı ekran boyutlarında taşma veya kesilme olmamasını kontrol et.

### 4. Formlar ve Etkileşim
- Gelir/gider formunda başlık, tutar, kategori, tarih ve işlem türü
  alanları olsun.
- Formlarda boş alanları ve sıfırdan küçük tutarları doğrula; hatayı
  kullanıcıya anlaşılır şekilde göster.
- Ekle, düzenle, sil ve filtrele etkileşimleri çalışır durumda olsun.
- Önemli silme işlemlerinde onay diyaloğu kullan.
- İşlem tamamlandığında SnackBar veya uygun bir geri bildirim göster.
- Butonları yalnızca görsel bırakma; her birinin tanımlı işlevi olsun.

### 5. Veri ve Hesaplamalar
- İlk sürümde yerel veri saklama yaklaşımını kullan.
- Gelir, gider ve birikim türlerini birbirinden ayır.
- Toplam bakiye, kategori toplamları, bütçe kullanımı ve hedef
  yüzdesini kayıtlı verilerden hesapla.
- Hedef ilerlemesi: savedAmount / targetAmount; sıfıra bölme durumunu
  önle ve sonucu geçerli aralıkta göster.
- Aylık/haftalık filtrelerde seçilen tarih aralığını doğru uygula.
- Kayıtlar uygulama yeniden açıldığında korunmalı.
- Örnek veriler kullanılacaksa bunları açıkça demo verisi olarak
  belirt.

### 6. Grafikler ve Raporlar
- Pasta grafiği kategori dağılımı için; çubuk grafiği gün, hafta veya
  ay karşılaştırması için kullan.
- Grafikler boş veri durumunda hata vermesin; açıklayıcı boş ekran
  göster.
- Raporlarda seçili dönemi ve kullanılan tutarları açıkça belirt.
- Geçmiş veri yetersizse bütçe önerisini kesin tahmin gibi sunma.

### 7. Test ve Kontrol
Her aşamadan sonra: - Uygulamanın derlenip çalıştığını kontrol et. -
Form doğrulamasını ve temel butonları dene. - Ekleme, düzenleme ve silme
işlemlerini kontrol et. - Açık/koyu tema ve ekran taşmalarını kontrol
et. - Hata varsa yeni özellik eklemeden önce düzelt.

### 8. Çalışma Biçimi
- Bir seferde tek bir geliştirme aşamasını tamamla.
- Büyük değişikliklerden önce kısa plan sun.
- Kod üretirken mevcut proje yapısına ve import yollarına uy.
- Tamamlanan özellikleri ve çalıştırılması gereken komutları kısa
  şekilde bildir.
- PROJECT.md kapsamı dışına çıkma; belirsiz noktada en basit, tutarlı
  çözümü seç.