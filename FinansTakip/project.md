## Finans Takip Uygulaması

### 1. Proje Özeti
Kullanıcıların gelir, gider, bütçe, düzenli ödemeler ve birikim
hedeflerini takip edebildiği; finansal durumunu grafiklerle görebildiği
modern bir Flutter uygulaması.

### 2. Proje Amacı
Bilinçsiz harcamaları azaltmaya yardımcı olmak, bütçe yönetimini
kolaylaştırmak ve kullanıcıların birikim hedeflerine motive edici,
görsel bir deneyimle ulaşmasını desteklemek.

### 3. Hedef Kitle
Öğrenciler ve kişisel gelir-gider takibini kolayca yapmak isteyen genel
kullanıcılar.

### 4. Kullanılacak Teknolojiler
- Frontend: Flutter ve Dart
- Arayüz: Material Design 3
- Tema: Açık/koyu tema desteği
- Veri: İlk sürümde yerel veri saklama; gerçek banka bağlantısı
  veya zorunlu backend kullanılmayacak.
- Grafikler: Projede kurulumu uygun, basit bir grafik bileşeni
  veya mevcut Flutter araçları
- Yeni paket eklemeden önce gerekliliği değerlendir; gereksiz
  bağımlılık kullanma.

### 5. Tasarım Dili
Editorial Finance ve Dreamy Money stilleri birleştirilecektir. Orman
yeşili, sıcak krem ve kırık beyaz; lila ve pastel sarı dokunuşlarla
dengelenecektir. Büyük ve modern tipografi, sade grafikler,
yuvarlatılmış kartlar ve estetik fotoğraf kolajları kullanılacaktır.
Tasarım profesyonel ve premium görünürken kişisel, sıcak ve
paylaşılabilir bir his vermelidir. Renkler okunabilirliği azaltmamalı;
açık ve koyu temada tutarlı çalışmalıdır.


### 6. Sayfa Hiyerarşisi
Alt gezinme çubuğunda 5 ana bölüm bulunacaktır.

Genel Bakış:
Toplam bakiye, gelir-gider özeti, bütçe ilerlemesi, yaklaşan ödemeler,
son işlemler ve öne çıkan birikim hedefi. 

İşlemler:
Gelir/gider ekleme formu; açıklama, tutar, kategori, tarih ve işlem
türü. İşlemleri görüntüleme, düzenleme ve silme. 

Analizler:
Kategori bazlı pasta grafik, gün/hafta/ay bazlı çubuk grafikler ve
tarih/kategori filtreleri.   

Hayallerim:
Fotoğraflı vision
board, hedef adı, hedef tutarı, birikmiş tutar, öncelik ve ilerleme
çubuğu.

Bütçe ve Ödemeler:
Aylık ve kategori bazlı limitler,
kira/fatura/abonelik kayıtları, ödeme tarihleri ve yaklaşan ödemeler.

Raporlar:
Analizler bölümünden erişilir. Aylık gelir-gider
karşılaştırması, haftalık harcama özeti, tasarruf ilerlemesi ve
paylaşılabilir aylık özet kartı sunar.


### 7. Temel Özellikler
- Gelir, gider ve birikimleri kategoriye göre kaydetme.
- Form doğrulaması: boş alanları, geçersiz veya negatif tutarları
  engelleme.
- Aylık ve kategori bazlı bütçe limiti belirleme; limite yaklaşma/aşma
  durumunu görsel olarak belirtme.
- Düzenli ödemeleri tarih ve tutarla kaydetme; yaklaşan ödemeleri
  uygulama içinde gösterme.
- Birikim hedefleri ve vision board: görsel, hedef tutarı, öncelik ve
  ilerleme.
- Kategori dağılımı ve dönem karşılaştırma grafikleri.
- Önceki kayıtlar yeterliyse geçmiş harcamalara dayalı basit bütçe
  önerileri.
- Money Wrapped: Aylık gelir, gider, en yüksek harcama kategorisi
  ve hedef ilerlemesini özetleyen kartlar.
- Kullanıcının seçebileceği açık/koyu tema.

### 8. Veri Modeli
- Transaction: id, title, amount, category, date, type
  (gelir/gider/birikim), note (isteğe bağlı).
- Budget: id, month, category, limitAmount.
- SavingGoal: id, title, targetAmount, savedAmount, priority,
  imagePath (isteğe bağlı).
- RecurringPayment: id, title, amount, category, dueDate,
  repeatType.
- Bakiye, kategori toplamları ve grafik verileri kayıtlı işlemlerden
  hesaplanmalıdır; aynı değerler ayrı ayrı ve tutarsız biçimde
  saklanmamalıdır.
9. UI ve Etkileşim Kuralları
- Temel UI elemanları, butonlar ve etkileşimler kullanılmalı.
- Form yönetimi ve validasyonlar uygulanmalı.
- Material Design 3, tema yönetimi ve uygun diyaloglar kullanılmalı.
- Silme gibi önemli işlemlerde onay diyaloğu gösterilmeli.
- Boş listeler için açıklayıcı boş durum ekranları; işlem sonrası
  kullanıcıya geri bildirim sunulmalı.
- Para tutarları Türk lirası biçiminde gösterilmeli.
- Uygulama, gerçek banka hesabına bağlıymış veya gerçek zamanlı
  finansal tavsiye veriyormuş gibi davranmamalıdır.


### 10. Proje Aşamaları
- Aşama 1 --- Tasarım: Sayfa akışı, renk paleti ve temel
  bileşenler.
- Aşama 2 --- Temel işlevler: İşlem formu, listeleme,
  düzenleme/silme ve veri saklama.
- Aşama 3 --- Zenginleştirme: Bütçe, grafikler, hedefler, düzenli
  ödemeler ve raporlar.
- Aşama 4 --- Test ve teslim: Validasyon, açık/koyu tema, ekran
  taşmaları ve temel akışların kontrolü.


### 11. Geliştirme Notları
Önce çalışan ve anlaşılır bir temel sürüm oluştur. Özellikleri aşamalı
ekle; gereksiz karmaşıklık veya proje kapsamı dışında teknoloji
kullanma. Mevcut klasör yapısını incele ve kod yazmadan önce planla. Var
olan dosyaları ihtiyaç olmadan silme veya yeniden adlandırma.