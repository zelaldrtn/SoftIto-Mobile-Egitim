---
name: flutter-feature-scaffold
description: Flutter projelerinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter feature scaffold (modüler ekran iskeleti)
Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken Clean UI ve reaktif State kurallarına tam uyulmasını garanti altına alır.

## Temel Kurallar
1. **Asla tek dosyada toplama:**
   UI (`_view.dart`), State Controller (`_controller.dart`), Model (`_model.dart`) ve bileşenler (`widgets/`) ayrı ayrı açılmalıdır.
2. **State Yönetimi:**
   Basit ve reaktif durumlar için `ValueNotifier` kullanılmalıdır. Doğrudan devasa `StatefulWidget`lar yazarak işi karmaşıklaştırma.
3. **Const Zorunluluğu:**
   Mümkün olan tüm widget'larda `const` olmalıdır.

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen modül adlarını (örn: `water_tracker`), `lib/features/<feature_name>` altına kur:

```text
lib/features/<feature_name>
    controllers/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    view/
        <feature_name>_view.dart
    widgets/
        <feature_name>_card.dart
```

### Adım 2: Controller Dosyasını Yaz
`controllers/<feature_name>_controller.dart` içinde iş mantığı ve `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/foundation.dart';

class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final int dailyGoalWater = 2000; // 2 litre

  void addWater([int amount = 250]) {
    currentWater.value += amount;
  }

  void resetWater() {
    currentWater.value = 0;
  }

  void dispose() {
    currentWater.dispose();
  }
}
```

### Adım 3: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metotlarını içerecek şekilde `immutable` olarak tanımla.

### Adım 4: View Dosyasını Yaz
`view/<feature_name>_view.dart` dosyasında `StatelessWidget` ve `ValueListenableBuilder` kullanılarak UI katmanını oluştur.

### Adım 5: Widget Dosyasını Oluşturma
`widgets/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanılarak modüler UI parçaları oluştur.

### Adım 6: Clean Architecture Kurallarına Uyum
- **Separation of Concerns:** Her dosyanın belirli bir sorumluluğu olduğundan emin ol.
- **Reusability:** Widget'ları ve controller'ı diğer ekranlarda da kullanılabilecek şekilde tasarla.
- **Testability:** Her katman için ayrı testler yazabileceğinden emin ol.
