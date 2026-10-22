Amaç
PROJECT.md dosyasındaki gereksinimleri izleyerek DO IT uygulamasını adım adım geliştir. Öncelik çalışan, sade ve anlaşılır bir Flutter uygulamasıdır.
Zorunlu Kurallar
- Başlamadan önce PROJECT.md dosyasını oku ve mevcut Flutter proje yapısını incele.
- Flutter, Dart ve Material Design 3 dışında yeni teknoloji eklemeden önce gerçekten gerekli olup olmadığını değerlendir.
- Backend, çevrim içi veritabanı, Firebase, API veya giriş/kayıt sistemi oluşturma.
- Tüm kullanıcı verilerini cihazda yerel olarak sakla; uygulama yeniden açıldığında veriler korunmalı.
- Tasarımda PROJECT.md renklerini ve beş öğeli alt menüyü tutarlı uygula.
- Kullanıcı puan miktarını seçemesin. Puan kuralları tek bir ortak noktada tanımlansın.
- Bir alışkanlık aynı planlı tarihte ikinci kez puan kazandıramasın.
- Analiz ve Wrapped verilerini gerçek kayıtlardan hesapla; sahte istatistik üretme.
- Ekranlar arasında aynı verinin farklı veya çelişkili görünmesini önle.
- Her buton gerçek bir işlem yapsın. Henüz uygulanmamış özellikleri çalışıyormuş gibi gösterme.
- Değişken ve widget adlarını anlaşılır seç; gereksiz karmaşıklıktan kaçın.
Önerilen Proje Yapısı
- lib/main.dart: uygulama başlangıcı ve tema.
- lib/models/: alışkanlık, günlük kayıt, eşya ve rozet modelleri.
- lib/screens/: bugün, takvim, oda, analiz, profil ve Wrapped ekranları.
- lib/widgets/: tekrar kullanılabilir kartlar, grafikler ve alt menü.
- lib/services/: yerel depolama, puan/streak hesaplama ve bildirim işlemleri.
- lib/theme/: açık/koyu tema ve renkler.
  Mevcut projeye uyum sağla; çalışan yapıyı sebepsiz yere yeniden kurma.
Geliştirme Sırası
1. Mevcut dosyaları incele; eksik veya bozuk yapı varsa önce düzelt.
2. Tema, MaterialApp ve beş bölümlü alt navigasyonu kur.
3. Alışkanlık ekleme/düzenleme/silme ve yerel kayıtları çalışır hâle getir.
4. Günlük tamamlama, tek seferlik puan kazanımı ve streak mantığını uygula.
5. Takvim ve analizleri aynı kayıtlar üzerinden üret.
6. Oda mağazası, envanter ve satın alma kurallarını ekle.
7. Wrapped kartlarını gerçek aylık verilerden oluştur.
8. Profil, rozetler ve bildirim tercihlerini tamamla.
9. Uygulamayı çalıştır; hataları düzelt ve ana akışları test et.
Test Kontrol Listesi
- Uygulama kapanıp açıldığında alışkanlıklar ve puanlar korunuyor mu?
- Aynı alışkanlığa aynı gün tekrar dokununca puan yeniden veriliyor mu? Verilmemeli.
- Puan yetmeden eşya satın alınabiliyor mu? Alınamamalı.
- Satın alınan eşya envanterde kalıyor mu?
- Haftalık sıklıkta plan dışı gün streak'i bozuyor mu? Bozmamalı.
- Takvim, analiz ve Wrapped aynı kayıtlarla tutarlı mı?
- Boş durumlar ve hatalı form girişleri düzgün ele alınıyor mu?
- Açık/koyu tema ve alt navigasyon tüm ana ekranlarda tutarlı mı?
Çalışma Biçimi
Önce temel akışı tamamla ve test et. Sonra oyun ve Wrapped özelliklerini ekle. Büyük değişikliklerden sonra uygulamayı çalıştırıp hata kontrolü yap. Gereksiz paket, animasyon, ekran ve soyutlama ekleme. Belirsiz bir gereksinim varsa en basit, PROJECT.md ile uyumlu çözümü seç ve kararını kısa biçimde açıkla.