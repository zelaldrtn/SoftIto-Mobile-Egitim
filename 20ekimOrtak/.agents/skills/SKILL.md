---
description: flutter ile girişimcilere destek projesinde yeni bir özellik veya ekran geliştirilirken kullanılacak kuralları açıklar. 
---

# Flutter DestekBul Scaffold

Bu skill, DestekBul projesinde yeni bir özellik veya ekran geliştirilirken kullanılacak kuralları açıklar.
Geliştirme sırasında proje kökündeki `project.md` dosyası bağlayıcı kılavuz olarak kabul edilmelidir. Bu dosyadaki kurallar ile çelişen bir işlem yapılmamalıdır.

## Temel Kurallar

1. Kodlar tek bir dosyada toplanmamalıdır.
2. Her özellik kendi klasöründe geliştirilmelidir.
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

## Adım 6: Günlük Uygulamasına Özel Kurallar
### Tema
- Gündüz ve gece temaları proje genelinde tutarlı olmalıdır.
- Tema renkleri merkezi tema dosyalarından yönetilmelidir.
- Tema değiştiğinde ilgili ekranlar güncellenmelidir.

### Sosyal alan
- Kullanıcılar fotoğraf, video ekleyerek projelerini her detayıyla paylaşımlar yaparak tanıtabilmelidir.
- Kullanıcılar beğeni ve yorum yapabilmelidir.
- Kullanıcılar farklı kategorilerdeki projeleri listeleyebilmelidir.
- Paylaşımlar kategori, konu, popülerlik, yeni eklenen gibi filtrelerle sıralanabilmelidir.
- Kullanıcılar projeler hakkında konuşabilmelidir.
- Beğenilen projeler kaydedebilmeli.


## Adım 7: Kontrol Et

Her geliştirme sonrasında:

1. Değiştirilen dosyaları ve kodları incele.
2. `flutter analyze` komutunu çalıştır.
3. `flutter test` komutunu çalıştır.
4. Bulunan hataları düzelt veya giderilemeyen sorunları açıkla.
5. Uygulamayı çalıştırmak için gerekli komutu kullanıcıya bildir.

Komutların gerçekten çalıştırılmadığı durumlarda başarılı olduklarını iddia etme.

## Yanıt Standartları

- Kullanıcıya Türkçe ve anlaşılır açıklamalar yap.
- Hangi dosyanın neden oluşturulduğunu belirt.
- Yapılan değişiklikleri kısa ve net açıkla.
- Kullanıcı onayı olmadan kapsam dışı özellik ekleme.
- Projedeki kuralları değiştirmeden önce kullanıcıya danış.