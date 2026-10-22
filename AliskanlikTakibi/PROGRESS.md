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
  - Flutter ve iOS ortamı doğrulandı (Flutter 3.47.6 / Dart 3.13.5).
  - Takip dosyası (`PROGRESS.md`) oluşturuldu.

- [ ] **Aşama 1: Flutter Projesinin Kurulumu ve Bağımlılıklar**
  - Flutter projesinin oluşturulması (`aliskanlik_takibi`).
  - Gerekli yerel paketlerin eklenmesi (`shared_preferences`, `intl`, `flutter_svg` / `path_provider` vb.).
  - Proje yapısının `SKILL.md` ile uyumlu kurulması (`lib/models`, `lib/screens`, `lib/widgets`, `lib/services`, `lib/theme`).

- [ ] **Aşama 2: Tasarım Sistemi, Renk Paleti ve Tema (Açık/Koyu)**
  - `lib/theme/app_theme.dart` (Cream, Sage Green, Forest, Sand).
  - Material 3 uyumlu Light & Dark temalar.
  - Tipografi ve yuvarlatılmış kart stilleri.

- [ ] **Aşama 3: Veri Modelleri ve Yerel Depolama Servisi**
  - Alışkanlık Modeli (`Habit`, sıklık, zorluk, otomatik puan kuralları).
  - Günlük Kayıt Modeli (`HabitLog`, tarih, tamamlanma, kazanılan puan).
  - Eşya / Dekorasyon Modeli (`RoomItem`, kategori, fiyat, sahip olma durumu, konum).
  - Rozet Modeli (`BadgeItem`).
  - Yerel Depolama Servisi (`LocalStorageService` - SharedPreferences & JSON, kalıcılık garantisi).

- [ ] **Aşama 4: Ana İskelet ve Navigasyon (5 Sekme)**
  - Sabit alt menü: Bugün, Takvim, Odam, Analiz, Profil.
  - Durum yönetimi ve veri akışı.

- [ ] **Aşama 5: "Bugün" Ekranı ve Alışkanlık Yönetimi (Ekle/Düzenle/Sil/Duraklat)**
  - Karşılama, günlük ilerleme dairesi/yüzdesi, streak ve günlük puan göstergesi.
  - Alışkanlık kartları (tamamla/geri al, tekil puan garantisi).
  - Alışkanlık Ekle/Düzenle modal formu (otomatik puan hesaplama, doğrulama).

- [ ] **Aşama 6: "Takvim" Ekranı ve Günlük Aktivite Izgarası**
  - Aylık takvim, gün geçişleri.
  - Renkli aktivite ızgarası ve seçilen günün alışkanlıkları.
  - Planlı günlere duyarlı streak hesaplayıcı.

- [ ] **Aşama 7: "Odam" Ekranı, Mağaza ve Envanter**
  - Minimalist 2D/izometrik oda görselleştirmesi.
  - Puan bakiyesi, mağaza kataloğu, satın alma (yetersiz puan kontrolü).
  - Eşya envanteri ve odaya yerleştirme.
  - Streak kilometre taşı ödülleri.

- [ ] **Aşama 8: "Analiz" Ekranı ve "DO IT Wrapped"**
  - Gerçek yerel verilerden haftalık/aylık grafikler ve istatistikler.
  - Hikâye formatında kaydırılabilir aylık DO IT Wrapped kartları.
  - Boş durumların ele alınması.

- [ ] **Aşama 9: "Profil" Ekranı, Rozetler ve Ayarlar**
  - İsim/avatar düzenleme (yerel).
  - Rozet vitrini (başarımlar).
  - Tema seçimi (Sistem / Açık / Koyu).
  - Bildirim tercihleri & Uygulama bilgisi.

- [ ] **Aşama 10: Minimalist Logo Oluşturma & Varlıklar**
  - Uygulama temasına uygun minimalist logo ve ikon oluşturulması.

- [ ] **Aşama 11: Testler, iOS Simülatöründe Çalıştırma ve Doğrulama**
  - Simülatörün başlatılması ve uygulamanın derlenip çalıştırılması.
  - Veri kalıcılığı, puan kuralları ve tüm butonların test edilmesi.
