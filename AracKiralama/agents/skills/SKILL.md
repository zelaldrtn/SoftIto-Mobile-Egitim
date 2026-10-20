---
description: flutter ile araç kiralama projesinde yeni bir özellik veya ekran geliştirilirken kullanılacak kuralları açıklar. 
---

# Flutter Araç Kiralama Scaffold

Bu skill, Araç Kiralama projesinde yeni bir özellik veya ekran geliştirilirken kullanılacak kuralları açıklar.
Geliştirme sırasında proje kökündeki `project.md` dosyası bağlayıcı kılavuz olarak kabul edilmelidir. Bu dosyadaki kurallar ile çelişen bir işlem yapılmamalıdır.

## Temel Kurallar

1. Kodlar tek bir dosyada toplanmamalıdır.
2. Her özellik lib/features/ altında kendi klasöründe geliştirilmelidir. controllers/, models/, views/ ve widgets/ klasörleri yalnızca ihtiyaç olduğunda oluşturulmalıdır.
3. Arayüz, iş mantığı ve veri modelleri birbirinden ayrılmalıdır.
4. Basit ve reaktif durum yönetiminde `ValueNotifier` ve `ValueListenableBuilder` kullanılmalıdır.
5. Sayfa düzeyinde ağır `setState` kullanımından kaçınılmalıdır.
6. Statik ve değişmeyen widget'larda `const` kullanılmalıdır.
7. `build` metotları 40 satırı geçmemelidir.
8. Renkler ve tema ayarları ortak tema dosyalarından yönetilmelidir.

## Adım 1: Projeyi İncele

- Öncelikle `project.md` dosyasını oku.
- Projenin mevcut klasörlerini ve dosyalarını incele.
- Var olan kodları kontrol etmeden aynı amaçla yeni dosyalar oluşturma.
- Eksik veya çelişkili bir gereksinim varsa kullanıcıya bildir.

## Adım 2: Özellik Klasörlerini Oluştur

Yeni bir özellik gerektiğinde `lib/features/` altında uygun klasörü oluştur.

Her özellik için gerektiği durumlarda şu klasörleri kullan:

- `controllers/`: İş mantığı ve durum yönetimi.
- `models/`: Özelliğe ait veri modelleri.
- `views/`: Ana ekranlar.
- `widgets/`: Tekrar kullanılabilir arayüz parçaları.

Her klasöre gereksiz veya kullanılmayacak dosyalar ekleme.

## Adım 3: Controller Oluştur

- Controller, ilgili özelliğin iş mantığını yönetmelidir.
- Değişen değerler uygun `ValueNotifier` nesneleriyle tutulabilir.
- Arayüz, bu değerleri `ValueListenableBuilder` aracılığıyla dinleyebilir.
- Kullanılmayan dinleyiciler uygun şekilde temizlenmelidir.
- İş mantığı mümkün olduğunca arayüz kodlarından bağımsız olmalıdır.

## Adım 4: Model Oluştur

- Bir özelliğin verileri birden fazla alana sahipse uygun bir model oluştur.
- Model alanları anlaşılır ve ihtiyaca uygun olmalıdır.
- Gereksiz özellikler eklenmemelidir.
- Verilerin kalıcı olarak saklandığı izlenimi verilmemelidir; günlük verileri şimdilik bellekte tutulacaktır.

## Adım 5: Ekran ve Widget Oluştur

- Ekranların arayüzü `views/` altında bulunmalıdır.
- Tekrar kullanılabilen parçalar `widgets/` altında tanımlanmalıdır.
- Ekranlar controller üzerinden yönetilen verilere uygun şekilde tepki vermelidir.
- Tema renkleri ve metin stilleri proje kurallarına uygun kullanılmalıdır.
- Büyük `build` metotları daha küçük widget'lara ayrılmalıdır.


## Adım 6: Temel UI Elemanları ve Etkileşimler

- Material Design 3 bileşenlerini tercih et.
- Butonlar, kartlar, metin alanları, açılır listeler ve tarih seçiciler tutarlı kullanılmalıdır.
- Her butonun gerçek ve tanımlı bir işlevi olmalıdır.
- İşlevi henüz uygulanmamış butonlar çalışıyormuş gibi gösterilmemelidir.
- Tekrar kullanılan bileşenler uygun `widgets/` klasöründe tutulmalıdır.
- Yüklenme, boş liste ve hata durumları kullanıcıya anlaşılır şekilde gösterilmelidir.
- Sayfalar arası geçişlerde mevcut navigasyon yapısı kullanılmalıdır.
- Başarılı ve başarısız işlemlerde kullanıcıya geri bildirim verilmelidir.

## Adım 7: Form Yönetimi ve Validasyonlar

- Formlarda `Form`, `GlobalKey<FormState>` ve `TextFormField` kullan.
- Her alan için ihtiyaca uygun `validator` tanımla.
- Zorunlu alanlar boş bırakılamamalıdır.
- E-posta, şifre, fiyat ve tarih alanları doğrulanmalıdır.
- Hata mesajları Türkçe ve anlaşılır olmalıdır.
- Form geçersiz olduğunda kayıt veya rezervasyon işlemi başlatılmamalıdır.
- Controller kullanıldığında `dispose()` çağrılmalıdır.
- Tarih aralığı ve toplam kiralama ücreti doğru hesaplanmalıdır.
- Başarılı işlem sonrasında form durumu ve kullanıcı geri bildirimi düzenlenmelidir.

## Adım 8: Kullanıcı Girişi ve Rol Yönetimi

- Uygulamada iki kullanıcı rolü bulunur: `aracSahibi` ve `kiralayan`.
- Kayıt sırasında kullanıcı türü belirlenmelidir.
- Giriş sonrasında kullanıcı uygun ana ekrana yönlendirilmelidir.
- Araç sahibi araç ekleyebilir, kendi ilanlarını düzenleyebilir ve rezervasyon taleplerini yönetebilir.
- Kiralayan araçları inceleyebilir ve rezervasyon talebi oluşturabilir.
- Kullanıcı yalnızca rolüne ve yetkisine uygun işlemleri yapabilmelidir.
- Gerçek kimlik doğrulama sistemi yoksa giriş işlemi demo olarak belirtilmelidir.
- Kullanıcı rolü kontrolü tek başına gerçek bir güvenlik mekanizması olarak kabul edilmemelidir.

## Adım 9: Material Design 3 ve Tema Yönetimi

- `MaterialApp` içinde `useMaterial3: true` kullanılmalıdır.
- `ThemeData`, `theme`, `darkTheme` ve `themeMode` yapılandırılmalıdır.
- Açık, koyu ve sistem teması desteklenmelidir.
- Tema renkleri merkezi tema dosyalarından yönetilmelidir.
- Ekranlarda sabit renkler yerine uygun tema renkleri kullanılmalıdır.
- Metin, arka plan, kart ve buton kontrastı her iki temada da okunabilir olmalıdır.
- Tema değişimi mevcut durum yönetimi yaklaşımıyla uygulanmalıdır.

## Adım 10: Diyaloglar ve İşlem Onayları

- Onay gerektiren işlemlerde `AlertDialog` veya uygun Material dialog bileşeni kullanılmalıdır.
- Araç silme, rezervasyon iptali ve benzeri işlemler kullanıcı onayı olmadan tamamlanmamalıdır.
- Diyalogların onay ve iptal butonları doğru çalışmalıdır.
- Basit bilgilendirmelerde `SnackBar` kullanılabilir.
- Diyalog açıkken işlem sonucu belirsiz bırakılmamalıdır.

## Adım 11: Kod Kalitesi ve Kontrol

- Yeni kodlar mevcut proje yapısına uygun olmalıdır.
- Gereksiz paket, dosya ve soyutlamalar eklenmemelidir.
- `const` kullanılabilecek yerlerde tercih edilmelidir.
- `build` metotları mümkün olduğunca 40 satırın altında tutulmalıdır.
- Kullanılmayan değişkenler ve dinleyiciler temizlenmelidir.
- Değişikliklerden sonra `flutter analyze` çalıştırılmalı ve bulunan hatalar giderilmelidir.
- Tamamlanan özellikler ve bilinen eksiklikler kısaca raporlanmalıdır.