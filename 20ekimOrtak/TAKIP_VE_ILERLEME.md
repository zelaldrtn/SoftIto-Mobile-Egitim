# Destek Bul - Proje Geliştirme ve İşlem Takip Günlüğü

Bu döküman, **Destek Bul** ("Girişimcilere Destek") Flutter projesinin başlangıcından iOS simülatöründe çalıştırılmasına ve eklenen yeni özelliklerin (Özel Kategori & Yatırımcı/Girişimci Login Sistemi) entegrasyonuna kadar geçen tüm adımları, mimari kararları, uygulanan kuralları ve test sonuçlarını anlık ve detaylı olarak kayıt altına almaktadır.

---

## 📌 Proje Genel Bilgileri
- **Uygulama Adı:** Destek Bul
- **Görünen Ad (iOS CFBundleDisplayName):** `Destek Bul`
- **Paket / Bundle ID:** `com.destekbul.destekBul`
- **Mimari:** Feature-First (Özellik Bazlı) Mimari
- **Tasarım:** Material 3, Çift Tema (Aydınlık & Karanlık Mod), `ValueNotifier<ThemeMode>`
- **Durum Yönetimi (State):** Saf Flutter / Dart reaktif mimarisi (`ValueNotifier`, `ValueListenableBuilder`)
- **Hedef Cihaz:** iOS Simulator (iPhone 17 - iOS 27.0, Booted)

---

## 📋 İşlem Adımları ve Takip Tablosu

| No | Adım / İşlem | Durum | Açıklama |
|---|---|---|---|
| 1 | Proje Analizi ve Gereksinimlerin Çıkarılması | ✅ Tamamlandı | `kontrol.md`, `project.md` ve `.agents/skills/SKILL.md` incelendi. |
| 2 | Takip Dosyası Oluşturulması | ✅ Tamamlandı | `TAKIP_VE_ILERLEME.md` oluşturuldu ve güncel tutuldu. |
| 3 | Flutter Projesinin İskeletinin Kurulması | ✅ Tamamlandı | `flutter create --org com.destekbul --project-name destek_bul .` ile iskelet kuruldu. |
| 4 | Core Klasörü & Tema / Renk Sisteminin İnşası | ✅ Tamamlandı | `app_colors.dart`, `app_theme.dart`, `theme_controller.dart` oluşturuldu. |
| 5 | Girişim Destek / Sosyal Özellik Modülünün Kodlanması | ✅ Tamamlandı | Model, Controller, View ve Widget'lar (<40 satır kuralına uygun) kodlandı. |
| 6 | Destek Bul Logosu ve Uygulama İkonlarının Üretimi | ✅ Tamamlandı | Roket + ampul + yeşil filiz temalı logo üretildi; iOS `AppIcon.appiconset` ve `assets/images/` oluşturuldu. |
| 7 | iOS Yapılandırması (Info.plist / Display Name) | ✅ Tamamlandı | `CFBundleDisplayName` "Destek Bul" olarak yapılandırıldı. ATS ağ erişimi açıldı. |
| 8 | Statik Kod Analizi (`flutter analyze`) | ✅ Tamamlandı | 0 hata, 0 uyarı şartı eksiksiz sağlandı. |
| 9 | Birim ve Widget Testleri (`flutter test`) | ✅ Tamamlandı | 8/8 test başarıyla geçti. |
| 10 | iOS Simülatöründe Çalıştırma (`flutter run`) | ✅ Tamamlandı | iPhone 17 simülatöründe Xcode ile derlenip başarıyla başlatıldı ve doğrulandı. |
| 11 | **Yeni Özellik: Özel Kategori Girişi** | ✅ Tamamlandı | Kullanıcının kendi belirlediği kategoriyi girme ve dinamik filtreleme desteği eklendi. |
| 12 | **Yeni Özellik: Yatırımcı & Girişimci Login Sistemi** | ✅ Tamamlandı | Yatırımcı girişi ve Yatırım Alan Kişi girişi için `features/auth/` modülü kodlandı. |

---

## 🆕 Eklenen Yeni Özellikler

### 1. "Kullanıcı Kendi Belirlediği Kategoriyi Girebilmeli"
- `ProjectsController` üzerinde dinamik `categoriesNotifier` (`ValueNotifier<List<String>>`) kuruldu.
- `addCategory(String category)` ile mükerrer kontrolü yapılarak kullanıcı kategorileri eklendi.
- Kategori filtre barında `_AddCategoryChip` ("+ Kategori Ekle") ve `_AddCategoryDialog` ile kullanıcıların arayüzden yeni kategori belirlemesi sağlandı.
- `CreateProjectView` içerisine `'+ Kendi Kategorini Belirle / Yaz...'` seçeneği ve dinamik metin alanı eklendi.

### 2. "Yatırımcı Girişi ve Yatırım Alan Kişi Girişi Login Sistemi"
- **Rol Modeli (`UserRole`):** `UserRole.investor` (Yatırımcı) ve `UserRole.entrepreneur` (Yatırım Alan Girişimci) rolleri oluşturuldu.
- **Kullanıcı Modeli (`UserModel`):** Ad, e-posta, rol, unvan, profil görseli, yatırım bütçesi ve aktif girişim sayısı alanları modellendi.
- **Kimlik Doğrulama Kontrolörü (`AuthController`):** Reaktif `currentUserNotifier` ve `selectedRoleNotifier` ile oturum açma, rol seçimi, demo hızlı giriş ve oturum kapatma fonksiyonları yazıldı.
- **Giriş Ekranı (`LoginView`):**
  - Üst kısımda "Destek Bul" logosu ve sloganı.
  - Yatırımcı / Yatırım Alan Girişimci geçiş sekmesi (`RoleSelectorTab`).
  - Seçili rolün avantajlarını özetleyen dinamik bilgi kartı (`RoleInfoCard`).
  - Ad soyad, e-posta ve şifre doğrulama alanları (`_LoginFormFields`).
  - "Giriş Yap / Devam Et" ana butonu ve tek tıkla test sağlayan "Demo Yatırımcı" ile "Demo Girişimci" aksiyonları.
- **Kullanıcı Profil ve Rol Rozeti Butonu (`UserProfileButton`):**
  - Ana ekranda (AppBar) kullanıcının rolünü rozet olarak gösterir ("Yatırımcı" veya "Girişimci").
  - Tıklandığında profil detayları modalı açılır ve tek tıkla "Çıkış Yap" imkanı sunarak `LoginView` ekranına dönüş sağlar.

---

## 🏗️ Mimari Dosya Yapısı

```text
lib/
  core/
    constants/
      app_colors.dart            # Aydınlık ve Karanlık mod renk paletleri
    theme/
      app_theme.dart             # Material 3 lightTheme ve darkTheme
      theme_controller.dart      # ValueNotifier<ThemeMode> reaktif tema yönetimi
  features/
    auth/                        # Yatırımcı & Girişimci Kimlik Doğrulama Modülü
      controllers/
        auth_controller.dart     # Oturum açma, rol belirleme ve çıkış mantığı
      models/
        user_model.dart          # Kullanıcı profil veri modeli
        user_role.dart           # Yatırımcı / Girişimci enum ve tanımları
      views/
        login_view.dart          # Yatırımcı & Yatırım Alan Kişi giriş ekranı
      widgets/
        role_selector_tab.dart   # Yatırımcı ve Girişimci geçiş sekmesi
        role_info_card.dart      # Seçili rol bilgi ve avantaj kartı
        user_profile_button.dart # AppBar profil butonu, rol rozeti ve çıkış modalı
    projects/
      controllers/
        projects_controller.dart # Dinamik kategoriler, filtreleme, arama, fonlama
      models/
        project_model.dart       # Girişim projesi veri modeli
        comment_model.dart       # Soru-cevap ve tartışma modeli
      views/
        home_view.dart           # Girişim vitrini, arama, filtre çipleri ve akış listesi
        project_detail_view.dart # Proje detay, video, fonlama ve tartışma ekranı
        create_project_view.dart # Özel kategori destekli yeni girişim formu
        saved_projects_view.dart # Kaydedilen projeler listesi
      widgets/
        project_card.dart        # Modüler girişim kartı
        project_card_header.dart # Görsel, kategori ve yer imi
        project_card_footer.dart # Beğeni, yorum ve destek ol butonları
        funding_progress_bar.dart# Dinamik yüzde ve fonlama ilerleme çubuğu
        category_filter_chips.dart # Dinamik kategori listesi ve kategori ekleme
        sort_filter_menu.dart    # Sıralama menüsü
        support_dialog.dart      # Fonlama desteği seçme diyaloğu
        theme_toggle_button.dart # Aydınlık/Karanlık mod tek tık geçiş butonu
  main.dart                      # DestekBulApp (Tema ve Auth state'ine göre reaktif geçiş)
```

---

## 🧪 Test ve Analiz Sonuçları

### 1. Statik Kod Analizi (`flutter analyze`)
```bash
flutter analyze
```
**Çıktı:**
```text
Analyzing 20ekimOrtak...
No issues found! (ran in 2.1s)
```
*0 hata ve 0 uyarı ile tamamlandı.*

### 2. Birim ve Widget Testleri (`flutter test`)
```bash
flutter test
```
**Çıktı:**
```text
00:00 +0: Destek Bul Unit & Smoke Testleri ProjectsController başlangıç verilerini başarıyla yükler
00:00 +1: Destek Bul Unit & Smoke Testleri Tema değiştirme işlevi doğru çalışır
00:00 +2: Destek Bul Unit & Smoke Testleri Projeyi beğenme ve kaydetme state değişiklikleri doğru yansır
00:00 +3: Destek Bul Unit & Smoke Testleri Destek Bul arama ve filtreleme çalışır
00:00 +4: Destek Bul Unit & Smoke Testleri Kullanıcı kendi belirlediği kategoriyi ekleyebilir ve liste güncellenir
00:00 +5: Destek Bul Unit & Smoke Testleri Yatırımcı ve Girişimci oturum açma ve kapatma doğru çalışır
00:00 +6: Destek Bul Unit & Smoke Testleri DestekBulApp oturum açılmamışken LoginView ekranını gösterir
00:00 +7: Destek Bul Unit & Smoke Testleri DestekBulApp oturum açılınca HomeView ekranını gösterir
00:00 +8: All tests passed!
```
*8/8 test başarıyla geçti.*

---

## 📱 iOS Simülatör Canlı Durumu
- Uygulama **iPhone 17 (iOS 27.0)** simülatöründe güncellendi.
- Yeni **Login Sistemi** karşılayıcı ekran olarak çalışmakta olup, Yatırımcı ve Girişimci rolleri arasında anında geçiş yapılabilmektedir.
