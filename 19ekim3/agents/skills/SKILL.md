---
name: flutter-feature-scaffold
description: Flutter projelerinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini, UI ayrımını, çift tema desteğini ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran veya işlev modülü açarken Clean UI, reaktif State kuralları ve [`project.md`](file:///Users/d1-22/Desktop/19ekim3/project.md) belgesindeki mimari standartlara tam uyulmasını garanti altına alır.

---

## Yetenek Yardımcı Kaynakları (Companion Resources)
Bu yetenek, geliştirme sürecini hızlandırmak ve standartları korumak için 3 temel kaynak içerir:
- **State Akış Kılavuzu:** [`references/state_flow.md`](file:///Users/d1-22/Desktop/19ekim3/agents/skills/references/state_flow.md) - Reaktif akış, ValueNotifier yaşam döngüsü, Mermaid diyagramları ve tema yönetimi.
- **Eksiksiz Örnek Ekran:** [`examples/sample_screen.dart`](file:///Users/d1-22/Desktop/19ekim3/agents/skills/examples/sample_screen.dart) - Çift tema, model, controller, view ve <40 satır alt widget'ları içeren eksiksiz Dart kodu.
- **Otomasyon Betiği:** [`script/generate.feature.sh`](file:///Users/d1-22/Desktop/19ekim3/agents/skills/script/generate.feature.sh) - Yeni bir feature iskeletini ve testlerini tek komutla üreten kabuk betiği.

---

## Temel Kurallar (Kırmızı Çizgiler)

1. **Asla Tek Dosyada Toplama (Feature-Based):**
   Her modül `lib/features/<feature_name>/` altında kendi klasöründe olmalıdır:
   - Görünüm: `view/<feature_name>_view.dart`
   - Durum Yöneticisi: `controllers/<feature_name>_controller.dart`
   - Model: `models/<feature_name>_model.dart`
   - Alt Bileşenler: `widgets/<feature_name>_*.dart`
2. **Reaktif State Yönetimi (Saf Flutter/Dart):**
   - Basit ve reaktif durumlar için `ValueNotifier<T>` ve `ValueListenableBuilder<T>` kullanılmalıdır.
   - Sayfa düzeyinde ağır `setState` **KULLANILMAYACAKTIR**. Yalnızca yerel arayüz durumunu (örneğin buton animasyonları, yerel metin kontrolü) yöneten `StatefulWidget` kabul edilir.
   - Harici ağır durum paketleri (Bloc, Riverpod vb.) yasaktır.
3. **`const` Zorunluluğu:**
   Statik tanımlanabilecek tüm widget, padding ve stillerde `const` zorunludur.
4. **40 Satır Kuralı:**
   Büyük `build` metotları yasaktır. 40 satırı geçen `build` metotları `widgets/` altına bağımsız özel widget'lar olarak yazılacaktır.
5. **Tema Uyumluluğu:**
   Renk ve metin stilleri kesinlikle `Theme.of(context)` ve tema paletlerinden (**Dark Obsidian & Neon** / **Light Snow & Dinamik Enerji**) alınmalıdır.

---

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen modül adını (örn: `water_tracker`, `workout`), `lib/features/<feature_name>/` altına kur:

```text
lib/features/<feature_name>/
  ├── controllers/
  │   └── <feature_name>_controller.dart
  ├── models/
  │   └── <feature_name>_model.dart
  ├── view/
  │   └── <feature_name>_view.dart
  └── widgets/
      ├── <feature_name>_card.dart
      └── <feature_name>_actions.dart
```

*(Not: Bu yapıyı [`script/generate.feature.sh <feature_name>`](file:///Users/d1-22/Desktop/19ekim3/agents/skills/script/generate.feature.sh) komutu ile otomatik üretebilirsiniz).*

---

### Adım 2: Controller Dosyasını Yaz
`controllers/<feature_name>_controller.dart` içinde mantığı ve `ValueNotifier` tanımlarını oluştur, `dispose` metodunu ekle:

```dart
import 'package:flutter/foundation.dart';
import '../models/<feature_name>_model.dart';

class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  static const int dailyGoalWater = 2000; // 2 litre

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

---

### Adım 3: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metotlarını içerecek şekilde `immutable` olarak tanımla:

```dart
import 'package:flutter/foundation.dart';

@immutable
class WaterIntakeModel {
  final String id;
  final String beverageName;
  final int amountMl;
  final DateTime timestamp;

  const WaterIntakeModel({
    required this.id,
    required this.beverageName,
    required this.amountMl,
    required this.timestamp,
  });

  WaterIntakeModel copyWith({
    String? id,
    String? beverageName,
    int? amountMl,
    DateTime? timestamp,
  }) {
    return WaterIntakeModel(
      id: id ?? this.id,
      beverageName: beverageName ?? this.beverageName,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      id: json['id'] as String? ?? '',
      beverageName: json['beverageName'] as String? ?? 'Su',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'beverageName': beverageName,
        'amountMl': amountMl,
        'timestamp': timestamp.toIso8601String(),
      };
}
```

---

### Adım 4: View Dosyasını Yaz (Maksimum 40 Satır Build)
`view/<feature_name>_view.dart` dosyasında `StatelessWidget` kullanılarak UI katmanını oluştur:

```dart
import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';
import '../widgets/water_tracker_card.dart';
import '../widgets/water_tracker_actions.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Susadım - Su Takibi'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WaterTrackerCard(controller: controller),
              const SizedBox(height: 16),
              WaterTrackerActions(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

### Adım 5: Widget Dosyasını Oluşturma
`widgets/<feature_name>_card.dart` dosyasında `ValueListenableBuilder` ile izole reaktif bileşeni oluştur:

```dart
import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';

class WaterTrackerCard extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ValueListenableBuilder<int>(
          valueListenable: controller.currentWater,
          builder: (context, current, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$current / ${WaterTrackerController.dailyGoalWater} ml',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (current / WaterTrackerController.dailyGoalWater).clamp(0.0, 1.0),
                  minHeight: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

---

### Adım 6: Clean Architecture ve Doğrulama
- **Separation of Concerns:** Her dosyanın tek bir sorumluluğu olmalıdır.
- **Reusability:** Widget'lar ve controller diğer modüller tarafından tekrar kullanılabilir olmalıdır.
- **Testability:** Controller iş mantığı ve widget'lar ayrı ayrı test edilmelidir.
- **Doğrulama Komutları ([`project.md`](file:///Users/d1-22/Desktop/19ekim3/project.md)):**
  ```bash
  flutter analyze
  flutter test
  flutter run
  ```

---

## Sıkça Sorulan Sorular (SSS)

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Yeni bir ekran, özellik (feature) veya işlev modülü oluştururken bu yeteneği kullanmalısınız.

### Soru: Bu yeteneği hangi durumlarda kullanmamalıyım?
**Cevap:** Küçük bir hata düzeltmesi (bugfix) yaparken veya mevcut tek bir widget stilini güncellerken bu yetenek kullanılmamalıdır.
