## Girişimcilere Destek uygulaması
Bu döküman flutter projesinde geliştirme yapacak olan ajan (antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir klavuzdur. projede üretilen her kod satırı burdaki kurallara UYMAK ZORUNDADIR.

## 1. Proje Özeti ve teknolojiler
- **Uygulama adı:** DestekBul
- **Hedef Platformlar:** iOS ve Android öncelikli ardından web ve masaüstü platformları
- **Flutter SDK:** 3.29.0
- **Dart SDK:** 3.0.0
- **Tasarım dili:** Material 3, çift tema desteği (Karanlık Mod: Göz yormayan basit renkler, siyah, gri, sarı, yeşil renkleri; Aydınlık Mod: Göz yormayan beyaz, sarı, yeşil, mavi renkleri);
- **Tema Yönetimi Özelliği:** Kullanıcı arayüzden tek tıkla Karanlık ve Aydınlık mod arasında anında geçiş yapabilmelidir. Tema durumu `ValueNotifier<ThemeMode>` ile yönetilecektir.
- **Uygulama Özeti:** girişimcilere girişim sürecinde yardımcı olan bir uygulama olacak. aynı zamanda girişimcilerin network kazanabileceği bir uygulama olacak başka girişimciler girişimciilerin fikirlerini beğenebilecek takip edebilecek vs. girişimcilerin projelerini sergileyebilecekleri yatırımcıların yeni projeler keşfedebilecekleri bir platform olacak. mentörlük bulunabilir. uygulamada melek yatırımcılar da yer alabilir ve girişimcilere destek olabilir. 

## 2. Mimari yapı : Özellik bazlı
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
  core/
    extensions/
    constants/
      app_colors.dart
    theme/
      app_theme.dart
      theme_controller.dart
    
  features/
    water_tracker/
      controller/
      models/
      view/
      widget/
    workout/
      controller/
      models/
      view/
      widget/

  main.dart
```

### Sadece uygulama başlatma ve tema bölümleri


## 3. Kırmızı çizgiler kod kalite standartları
1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.
Büyük build metodları yasaktır, 40 satırı geçen build metodları özel widget'lara yazılacaktır.

3 - **Yasaklı Paketler:**
Projeye onay olmadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek API'lerini (ChangeNotifier / ValueNotifier vb.) kullanmak esastır.

## 4. Geliştirme analiz ve test komutları
Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
```bash 
flutter analyze
```

* **Birim ve widget testleri:**
```bash
flutter test
```

* **Projeyi çalıştırma:**
```bash
flutter run
```

## 5. Ajanın çıktı ve yanıt verme standartları
* **Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
* **Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.
* **Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
* **Doğrulama:** Kod yazdıktan sonra kullanıcıya "şimdi flutter analyze ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.