# DigiDia – Dijital Günlük Uygulaması

Bu belge, Antigravity'nin Flutter projesini geliştirirken uyması gereken kuralları içerir.

## 1. Proje Özeti

- **Uygulama adı:** DigiDia
- **Teknolojiler:** Flutter, Dart, Material 3
- **Amaç:** Takvim üzerinden günlük yazmak, günlükleri düzenlemek ve ruh hâlini emojiyle belirtmek.
- **Tasarım:** Sade, tatlı ve kullanıcı dostu.
- **Gündüz teması:** Pastel mor, lavanta ve lila.
- **Gece teması:** Koyu mor ve uyumlu koyu tonlar.
- Kullanıcı iki tema arasında geçiş yapabilmelidir.

## 2. Temel Özellikler

### 2.1. Takvim
- Ay ve yıl gösterilmeli, önceki ve sonraki aya geçilebilmelidir.
- Kullanıcı bir gün seçerek o günün günlüğünü açabilmelidir.
- Günlük yazılan günler takvimde ayırt edilmeli, seçilen ruh hâli emojisi gösterilmelidir.

### 2.2. Günlük
- Seçilen tarihin günlük ekranı açılmalıdır.
- Günlük yazılabilmeli, kaydedilebilmeli ve düzenlenebilmelidir.
- Boş günlük kaydedilmek istendiğinde kontrol yapılmalıdır.
- Her tarih için tek bir günlük kaydı tutulmalıdır.

### 2.3. Ruh Hâli ve Tema
- Kullanıcı günlük ekranında emoji seçebilmeli ve değiştirebilmelidir.
- Ruh hâli seçimi isteğe bağlı olmalıdır.
- Tema değişimi bütün ekranlara uygulanmalıdır.

### 2.4. Veri Yönetimi
- Günlük metni ve ruh hâli ilgili tarihle ilişkilendirilmelidir.
- Veriler şimdilik uygulama belleğinde tutulmalıdır; uygulama kapanınca kaybolabilir.
- Veritabanı, sunucu veya harici veri saklama sistemi kullanılmamalıdır.

## 3. Klasör Yapısı

Kodlar tek dosyada toplanmamalı, özelliklere göre ayrılmalıdır.

```text
lib/
  core/
    constants/
      app_colors.dart
    theme/
      app_theme.dart
  features/
    calendar/
      controllers/
      models/
      views/
      widgets/
    diary/
      controllers/
      models/
      views/
      widgets/
    mood/
      controllers/
      models/
      views/
      widgets/
  main.dart

assets/
  icons/
```

- `controllers/`: İş mantığı ve durum yönetimi.
- `models/`: Veri modelleri.
- `views/`: Ekranlar.
- `widgets/`: Tekrar kullanılabilir arayüz parçaları.
- `core/`: Ortak renk ve tema tanımları.

Yalnızca gerçekten gereken dosyalar oluşturulmalıdır.

## 4. Kodlama Kuralları

### State Yönetimi
- `ValueNotifier` ve `ValueListenableBuilder` kullanılmalıdır.
- Sayfa düzeyinde yoğun `setState` kullanımından kaçınılmalıdır.
- Değiştirilebilir veriler controller üzerinden yönetilmelidir.
- Modellerde `final` alanlar ve uygun olduğunda `copyWith()` kullanılmalıdır.
- Controller içindeki notifier nesneleri `dispose()` ile temizlenmelidir.

### Arayüz ve Tema
- Değişmeyen widget'larda `const` kullanılmalıdır.
- `build()` metotları 40 satırı geçmemelidir; büyük arayüzler küçük widget'lara ayrılmalıdır.
- Renkler `app_colors.dart`, temalar `app_theme.dart` dosyasında tutulmalıdır.
- Tema renkleri için uygun yerlerde `Theme.of(context)` kullanılmalıdır.

### Paket ve Teknoloji Sınırları
- Flutter ve Dart'ın yerleşik özellikleri önceliklidir.
- Kullanıcı onayı olmadan paket veya yeni teknoloji eklenmemelidir.
- Derste gösterilmeyen karmaşık mimariler kullanılmamalıdır.

## 5. Uygulama İkonu

Antigravity, uygulamanın pastel mor tasarımına uygun, özgün ve sade bir ikon hazırlamalıdır. Görsel `assets/icons/` altında tutulmalıdır. İkonu uygulamaya tanıtmak için ek paket gerekiyorsa önce kullanıcıdan onay alınmalıdır.

## 6. Geliştirme Sırası

1. Mevcut proje dosyalarını incele.
2. Proje boşsa Flutter projesinin oluşturulması için kullanıcıya yol göster.
3. Klasör yapısını, `main.dart` dosyasını ve temaları oluştur.
4. Takvim özelliğini geliştir.
5. Günlük yazma ve düzenleme özelliğini ekle.
6. Ruh hâli seçimini takvimle ilişkilendir.
7. Uygulama ikonunu hazırla.
8. Kodları analiz et ve testleri çalıştır.

Her aşamada bu kurallara uyulmalı; mevcut dosyalar incelenmeden rastgele değişiklik yapılmamalıdır.

## 7. Kontrol ve Yanıt Kuralları

- Değişikliklerden sonra `flutter analyze` ve `flutter test` çalıştırılmalıdır.
- Çalıştırılmayan kontroller başarılı olarak gösterilmemelidir.
- Antigravity, yanıtlarını Türkçe vermeli; değiştirilen dosyaları ve nedenlerini açıklamalıdır.
- Tamamlanmayan özellikler açıkça belirtilmeli, uygulamanın nasıl çalıştırılacağı anlatılmalıdır.

**Genel kural:** Bu belgeye ve `.agents/skills/flutter-diary-scaffold/SKILL.md` dosyasındaki kurallara uy. Kullanıcı onayı olmadan kapsam dışına çıkma.