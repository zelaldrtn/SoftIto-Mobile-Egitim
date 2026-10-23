DO IT — Project Definition
1. Proje Amacı
DO IT, kullanıcıların küçük ve pozitif alışkanlıklar kazanmasını sağlayan, devamlılığı streak sistemiyle destekleyen ve ilerlemeyi oda dekorasyonu ile ödüllendiren bir Flutter uygulamasıdır.
2. Teknoloji ve Sınırlar
- Flutter ve Dart kullan.
- Material Design 3 kullan.
- Veritabanı, backend, API, Firebase veya kullanıcı hesabı ekleme.
- Verileri cihazda yerel olarak sakla; uygulama kapanıp açılsa da korunmalı.
- Basit yerel depolama için shared_preferences veya uygun bir yerel dosya çözümü kullan. Veriler karmaşıklaşırsa Hive gibi yerel bir çözüm seç; uzak servis kullanma.
- Kod anlaşılır, modüler ve başlangıç seviyesinde takip edilebilir olsun.
3. Tasarım Sistemi
- Uygulama adı: DO IT.
- Stil: modern, sade, soft, güven veren; oyun bölümü eğlenceli ama çocukça olmayan bir tasarımda.
- Renkler: Cream #F5F1E8, Sage Green #63856B, Forest #263C33, Sand #E7C9A5.
- Açık ve koyu tema desteği; Material 3 tema yapısı kullan.
- Yuvarlatılmış kartlar, sade ikonlar, okunaklı yazılar ve tutarlı boşluklar kullan.
- Ekranları gereksiz kart, animasyon ve efektlerle kalabalıklaştırma.
4. Ana Navigasyon
Alt menü sabit olsun ve beş bölüm içersin:
1. Bugün
2. Takvim
3. Odam
4. Analiz
5. Profil
Alışkanlık ekleme/düzenleme bir form ekranı olarak açılsın. Wrapped, Analiz ekranından açılan ayrı bir hikâye görünümü olsun. Oda mağazası ve eşya envanteri Odam bölümünün alt ekranları olsun.
5. Ekranlar ve İşlevleri
Bugün
- Tarih, kısa karşılama ve günlük ilerleme yüzdesi/pasta grafik.
- Alışkanlık listesi; her kartta ad, ikon, hedef, puan ve tamamlama kutusu.
- Aktif streak ve bugün kazanılan puan.
- “Yeni alışkanlık ekle” butonu.
- Tamamlanan alışkanlık aynı gün tekrar puan vermesin.
Alışkanlık Ekle/Düzenle
- Ad, kategori, ikon, hedef, tekrar sıklığı ve isteğe bağlı hatırlatma saati.
- Tekrar seçenekleri: her gün, hafta içi, haftada belirli günler veya seçili günler.
- Puanı kullanıcı belirlemesin. Sistem hedef/zorluk için önceden tanımlı kurallarla otomatik puan atasın ve formda gösterilsin.
- Form doğrulaması yap; boş ad gibi geçersiz verileri kaydetme.
- Alışkanlık düzenleme, duraklatma ve silme işlemlerini destekle.
Takvim
- Aylık takvim, önceki/sonraki ay geçişi.
- Tamamlanan günleri sade renklerle gösteren aktivite ızgarası.
- Seçilen tarihte tamamlanan alışkanlıkları göster.
- Mevcut ve en uzun streak'i göster.
- Streak, alışkanlığın planlı günlerine göre hesaplansın; plan dışı günler zinciri bozmasın.
Odam
- Oda, Decor Life benzeri görsel açıdan zengin, mümkün olduğunca 3D görünümlü veya izometrik tasarıma sahip olmalı.
- Mobilyalar yalnızca ikon ve yazıyla temsil edilmemeli; görsel mobilya modelleri ve dekorasyonlar kullanılmalı.
- Kullanıcı kazandığı puanlarla mobilya satın alabilmeli ve odasını kişiselleştirebilmeli.
- Satın alınan eşyalar ve oda düzeni cihazda yerel olarak kaydedilmeli.
- Tasarım Flutter ile uyumlu, performanslı ve uygulanabilir olmalı. Gerçek 3D çok karmaşıksa öncelikle izometrik tasarım tercih edilmeli.
Analiz
- Haftalık/aylık tamamlama yüzdesi ve alışkanlık bazlı çubuk grafikler.
- En istikrarlı alışkanlık, toplam tamamlamalar, puanlar ve streak istatistikleri.
- Tüm değerler gerçek yerel kayıtlardan hesaplanmalı; örnek veriler gerçek kullanıcı verisi gibi gösterilmemeli.
- “DO IT Wrapped” kartıyla aylık özet görünümünü aç.
DO IT Wrapped
- Hikâye kartları şeklinde kaydırılabilir aylık özet.
- Yeni edinilen alışkanlıklar, tamamlanan günler, en istikrarlı alışkanlık ve kazanılan puanlar gibi gerçek istatistikleri göster.
- Yeterli veri yoksa uygun bir boş durum göster; sonuç uydurma.
- İlk sürümde paylaşım görseli zorunlu değil.
Profil
- İsteğe bağlı görünen profil adı/avatar; hesap veya giriş sistemi yok.
- Rozet koleksiyonu, tema tercihi, bildirim ayarları ve uygulama bilgisi.
- Rozetler ve ayarlar ayrı ana menü öğesi olmasın.
6. Puan ve Kayıt Kuralları
- Puanlar otomatik atanır; kullanıcı puan miktarını değiştiremez.
- Başlangıçta anlaşılır sabit bir puan tablosu kullan; örneğin çok kolay 3, kolay 5, orta 10, zor 15 puan.
- Her alışkanlık, her planlı tarih için en fazla bir kez tamamlanır ve puan kazandırır.
- Tamamlama kaydı, puan hareketi ve tarih tutarlı tutulmalı; tekrar dokunma ikinci ödül vermemeli.
- Eşya satın alma puan bakiyesini düşürür ve sahiplik kaydı oluşturur.
- Geçmiş kayıtları, alışkanlık sonradan düzenlendiğinde geriye dönük bozulmamalı.
- Kaçırılan günler için suçlayıcı metinler kullanma; kullanıcıyı yeniden başlamaya teşvik et.
- Bildirimler mümkün değilse veya izin yoksa uygulamanın geri kalanı çalışmaya devam etsin.
7. Genel Beklentiler
- Tüm butonlar ve menüler işlevsel olsun; boş/placeholder ekran bırakma.
- Yükleniyor, boş liste, doğrulama ve hata durumlarını ele al.
- Kodlamaya başlamadan önce mevcut proje yapısını incele ve çalışan kodu gereksiz yere bozma.
- Önce temel alışkanlık akışını ve yerel kayıtları tamamla; sonra takvim/analiz, ardından oda ve Wrapped özelliklerini geliştir.