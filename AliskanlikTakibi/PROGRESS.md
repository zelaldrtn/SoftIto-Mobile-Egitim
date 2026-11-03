# DO IT — Geliştirme Süreci ve İlerleme Günlüğü (PROGRESS.md)

Bu dosya, `PROJECT.md` ve `SKILL.md` yönergeleri doğrultusunda DO IT alışkanlık takip ve oda dekorasyon uygulamasının adım adım geliştirme aşamalarını, alınan kararları ve test sonuçlarını belgelemektedir.

---

## 📌 Proje Genel Bakışı
- **Uygulama Adı:** DO IT
- **Teknoloji:** Flutter (Dart, Material 3)
- **Veri Depolama:** Yerel depolama (SharedPreferences & Yerel JSON, sıfır backend/veritabanı)
- **Tasarım:** Modern, sade, soft (Krem `#F5F1E8`, Adaçayı Yeşili `#63856B`, Orman Yeşili `#263C33`, Kum `#E7C9A5`)
- **Navigasyon:** Bugün, Takvim, Odam, Analiz, Profil (5 ana sekme)

---

## 🚀 Geliştirme Aşamaları ve Durum

- [x] **Aşama 0: Hazırlık & Analiz**
  - `PROJECT.md` ve `SKILL.md` kuralları eksiksiz okundu.
  - Flutter ve macOS/iOS ortamı doğrulandı.
  - Takip dosyası (`PROGRESS.md`) oluşturuldu.

- [x] **Aşama 1: Flutter Projesinin Kurulumu ve Bağımlılıklar**
  - Flutter projesi ve bağımlılıkları doğrulandı (`shared_preferences`, `intl`, `provider`, `cupertino_icons`).
  - Proje mimarisi `SKILL.md` ile birebir uyumlu oluşturuldu (`lib/models`, `lib/screens`, `lib/widgets`, `lib/services`, `lib/theme`).

- [x] **Aşama 2: Tasarım Sistemi, Renk Paleti ve Tema (Açık/Koyu)**
  - `lib/theme/app_theme.dart` (Cream `#F5F1E8`, Sage Green `#63856B`, Forest `#263C33`, Sand `#E7C9A5`).
  - Material 3 uyumlu Light & Dark temalar, modern tipografi ve yuvarlatılmış kartlar uygulandı.

- [x] **Aşama 3: Veri Modelleri ve Yerel Depolama Servisi**
  - `lib/models/habit.dart`: Kategori, sıklık (her gün, hafta içi, seçili günler), otomatik zorluk puanı (3, 5, 10, 15), duraklatma ve planlı gün kontrolü.
  - `lib/models/habit_log.dart`: Tarih formatı (`YYYY-MM-DD`), tekil tamamlama garantisi, kazanılan puan.
  - `lib/models/room_item.dart`: 8 oda slotu (desk, plant, bookshelf, rug, wallArt, lamp, chair, trophy), streak kilometre taşı gereksinimleri, envanter sahipliği.
  - `lib/models/badge_item.dart`: Başarım rozetleri ve kilit açma koşulları.
  - `lib/models/user_profile.dart`: Yerel isim, avatar, tema tercihi, bildirim saati.
  - `lib/services/storage_service.dart`: SharedPreferences ile JSON serileştirme ve başlangıç tohum verileri.
  - `lib/services/habit_provider.dart`: Tamamlama başına tek puan kuralı, planlı günlere duyarlı streak hesaplayıcı, yetersiz bakiye engellemesi.

- [x] **Aşama 4: Ana İskelet ve Navigasyon (5 Sekme)**
  - `lib/screens/main_navigation_screen.dart` ve `lib/widgets/bottom_nav_bar.dart`:
    1. Bugün
    2. Takvim
    3. Odam
    4. Analiz
    5. Profil

- [x] **Aşama 5: "Bugün" Ekranı ve Alışkanlık Yönetimi (Ekle/Düzenle/Sil/Duraklat)**
  - `lib/screens/today_screen.dart`, `lib/widgets/circular_progress.dart`, `lib/widgets/habit_card.dart`.
  - Günlük karşılama, pasta ilerleme yüzdesi, aktif streak, bugün kazanılan puan.
  - `lib/screens/habit_form_screen.dart`: Form doğrulaması, otomatik zorluk puan göstergesi, ikon & sıklık seçici.

- [x] **Aşama 6: "Takvim" Ekranı ve Günlük Aktivite Izgarası**
  - `lib/screens/calendar_screen.dart`: Ay navigasyonu, aktivite ızgarası, seçilen günde tamamlanan alışkanlıklar listesi, aktif & en uzun streak sayaçları.

- [x] **Aşama 7: "Odam" Ekranı, Mağaza ve Envanter**
  - `lib/screens/room_screen.dart`: Mimari oda arka planı, 8 adet interaktif slot (çalışma masası, bitki, kütüphane, lambader vb.).
  - `lib/screens/room_store_screen.dart`: Kategori filtreli mağaza, streak kilitleri, puan kontrolü ve envanter yönetimi.

- [x] **Aşama 8: "Analiz" Ekranı ve "DO IT Wrapped"**
  - `lib/screens/analytics_screen.dart`: Son 7 gün çubuk grafikler, en istikrarlı alışkanlık, toplam tamamlama ve puan istatistikleri.
  - `lib/screens/wrapped_screen.dart`: Kaydırılabilir hikâye kartları, gerçek aylık özet, veri yoksa temiz boş durum ekranı.

- [x] **Aşama 9: "Profil" Ekranı, Rozetler ve Ayarlar**
  - `lib/screens/profile_screen.dart`: İsim/avatar düzenleme, rozet vitrini modalı, Sistem/Açık/Koyu tema seçimi, günlük hatırlatıcı saati.

- [x] **Aşama 10: Varlıklar ve Minimalist Görseller**
  - `assets/images/logo.png` varlığı korundu ve pubspec.yaml içinde tanımlandı.

- [x] **Aşama 11: Testler, iOS Simülatöründe Çalıştırma ve Canlı Doğrulama**
  - `flutter analyze`: 0 hata, 0 uyarı (temiz statik analiz).
  - `flutter test`: Tüm birim ve widget testleri başarıyla geçti (puan kuralları, çift puan engelleme, yetersiz bakiye kontrolü, 5 sekmeli ana navigasyon doğrulaması).
  - **iOS Simülatörü (iPhone 18 Pro)**: Uygulama derlendi, simülatöre yüklendi ve aktif olarak başlatıldı (`com.doit.aliskanlikTakibi`, PID 10694). Tüm başlık ve alt metin hizalamaları, responsive `Expanded` sarmalamaları ve DO IT tasarım sistemine ait yumuşak krem-yeşil renk paleti canlı simülatör ekran görüntüsüyle (`simulator_active.png`) doğrulandı.

- [x] **Aşama 12: Gerçek 3D Dekorasyon Oyunu Motoru (Floor Raycasting, Sürükle-Bırak & Z-Sorting)**
  - `ditredi` kütüphanesindeki Z-fighting, zemin kararması ve raycast eksikliği kökten çözüldü; bozuk software rasterizer tamamen projeden kaldırıldı.
  - Saf Flutter ve `vector_math` tabanlı yüksek performanslı **Custom 3D Game Engine** (`lib/widgets/game3d/`) inşa edildi:
    - `math3d.dart`: Spherical Camera3D, View-Projection matrisleri, Screen-to-World Floor Raycasting (dokunulan pikselin Y=0 zemin düzlemiyle kesişim hesabı).
    - `mesh3d.dart`: 3D Poligon, Backface Culling, Lambertian Diffuse + Ambient Shading, 6 yüzeyli kutu üretici.
    - `furniture_models_3d.dart`: Masa, sandalye, koltuk, yatak, gardırop/dolap, kitaplık & raf, halı, saksı bitkisi, lambader, duvar tablosu ve başarı kupası için tam detaylı 3D geometriler.
    - `room_scene_3d.dart`: 8x8 ahşap parke zemin karoları, segmentli duvarlar, pencere ve süpürgelikler; derinlik sıralaması (Painters algorithm) ile kusursuz kesintisiz render.
    - `room_game_view.dart`: Dokunarak seçme, zemin üzerinde serbest parmakla sürükleme, 90° döndürme, ızgara kilidi (snap-to-grid), 360° serbest kamera modu, preset açılar ve alt mobilya envanter tepsisi.
  - `RoomItem` modeline 3D koordinatlar (`positionX`, `positionZ`, `rotationY`) eklendi; SharedPreferences ile cihazda otomatik kaydedilip açılışta restore edilmesi sağlandı.
- [x] **Aşama 13: 4 Kritik Sorunun Kökten Çözümü & Doğrulaması**
  - **1. Tema Hatası Çözüldü:**
    - *Kök Neden:* `RoomScreen` içerisindeki `didChangeDependencies()` her rebuild olduğunda `_isNightMode = isDark;` çalıştırıyordu. 3D odadaki eşya sürüklendiğinde `HabitProvider`'daki `updateRoomItemPosition` metodu `notifyListeners()` çağırıyor, bu da açık temadayken gece modunu tetikleyip uygulamayı zorla koyu temaya geçiriyordu.
    - *Çözüm:* `_didInitNightMode` bayrağı eklendi; didChangeDependencies yalnızca ilk açılışta gece modunu ilklendiriyor. Sürükleme anında (`onPanUpdate`) yerel state değişkenleri (`_dragPosX`, `_dragPosZ`) kullanılarak gereksiz global rebuild ve tema sıçraması engellendi; sadece parmak kaldırıldığında (`onPanEnd`) tek seferde SharedPreferences'e yazılması sağlandı. Açık ve koyu tema bağımsız ve stabil hale getirildi.
  - **2. Mağaza & 3D Oda Bağlantısı ve Çift Satın Alma Engelleme:**
    - *Kök Neden:* Mağazadan satın alınan eşyalar yalnızca 2D odada görünüyordu; 3D koordinatlar atanmıyordu ve yerel kayıt ile yeni katalog eşyaları birleştiğinde mükerrer kayıt veya kayıp olabiliyordu.
    - *Çözüm:* `StorageService.loadRoomItems()` içine varsayılan katalog ile yerel kaydı birleştiren akıllı tekilleştirme (`merge`) eklendi. `HabitProvider.buyRoomItem()` içinde satın alınan eşyaya slotun 3D koordinatları (`positionX`, `positionZ`, `rotationY`) otomatik olarak atandı ve 3D odada anında görünür hale getirildi. Zaten sahip olunan bir eşyanın tekrar satın alınması (`isOwned` kontrolü) kesin olarak engellendi.
  - **3. Render & Gömülme Hatalarının Giderilmesi:**
    - *Kök Neden:* Painter's algorithm tek bir havuzda tüm poligonları sıralarken, geniş zemin karoları ve duvarlar mobilyaların merkez noktasından daha yakın algılanıp mobilyaların üstüne çiziliyor, eşyaların zemine gömülmüş veya yarım kesilmiş görünmesine yol açıyordu.
    - *Çözüm:* **Katmanlı Derinlik Mimarisi (Layered Depth Pipeline)** uygulandı: Zemin Karoları -> Duvarlar & Pencere -> Zemin Halıları -> Mobilyalar & Eşyalar -> Seçim Halkası & Yardımcı Çizgiler. Bu sayede zemin mobilyaların üzerine asla çizilemez; `math3d.dart` içine `clampNear: true` eklenerek kameraya yaklaşınca poligonların kaybolması engellendi.
  - **4. Veri Tutarlılığı ve SharedPreferences Senkronizasyonu:**
    - Satın alınan eşyalar, harcanan puanlar, mobilya 3D koordinatları (`positionX`, `positionZ`) ve 90 derecelik rotasyonlar (`rotationY`) yerel depolama ile tam uyumlu hale getirildi. Uygulama tamamen kapatılıp yeniden açıldığında tüm oda düzeni, eşyalar ve puanlar eksiksiz korunmaktadır.
  - **Test Sonuçları:**
    - `flutter analyze`: 0 hata, 0 uyarı (temiz analiz).
    - `flutter test`: 16 testin 16'sı da (%100) başarıyla geçti (`test/real_3d_room_test.dart`, `test/math_debug_test.dart`, `test/widget_test.dart`).

