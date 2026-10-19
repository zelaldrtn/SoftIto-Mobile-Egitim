#!/usr/bin/env bash
# ==============================================================================
# Susadım & Flutter Feature Scaffold - Modüler Feature Oluşturucu
# ==============================================================================
# Bu betik, project.md ve SKILL.md kurallarına tam uyumlu olarak belirtilen
# feature modülü için klasör yapısını, ValueNotifier controller'ını, immutable
# modelini, alt widget'lara ayrılmış view'ını ve birim testini otomatik üretir.
# ==============================================================================

set -euo pipefail

# Renkler
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Kullanım kontrolü
if [ $# -lt 1 ]; then
    echo -e "${RED}Hata: Feature adı belirtilmedi!${NC}"
    echo -e "Kullanım: ${YELLOW}./generate.feature.sh <feature_name> [proje_kok_dizini]${NC}"
    echo -e "Örnek:    ${GREEN}./generate.feature.sh workout${NC}"
    echo -e "Örnek:    ${GREEN}./generate.feature.sh water_tracker /Users/d1-22/Desktop/19ekim3${NC}"
    exit 1
fi

FEATURE_INPUT="$1"
PROJECT_ROOT="${2:-.}"

# snake_case temizliği
FEATURE_SNAKE=$(echo "$FEATURE_INPUT" | tr '[:upper:]' '[:lower:]' | tr '-' '_' | sed 's/[^a-z0-9_]//g')

# PascalCase dönüşümü
to_pascal_case() {
    echo "$1" | awk -F_ '{
        for (i=1; i<=NF; i++) {
            printf "%s%s", toupper(substr($i,1,1)), tolower(substr($i,2))
        }
    }'
}

FEATURE_PASCAL=$(to_pascal_case "$FEATURE_SNAKE")

echo -e "${BLUE}==> Feature Üretiliyor: ${GREEN}${FEATURE_SNAKE}${BLUE} (Sınıf: ${GREEN}${FEATURE_PASCAL}${BLUE})${NC}"

# Dizin yolları
LIB_FEATURE_DIR="${PROJECT_ROOT}/lib/features/${FEATURE_SNAKE}"
TEST_FEATURE_DIR="${PROJECT_ROOT}/test/features/${FEATURE_SNAKE}"

CONTROLLER_DIR="${LIB_FEATURE_DIR}/controllers"
MODEL_DIR="${LIB_FEATURE_DIR}/models"
VIEW_DIR="${LIB_FEATURE_DIR}/view"
WIDGET_DIR="${LIB_FEATURE_DIR}/widgets"
TEST_CONTROLLER_DIR="${TEST_FEATURE_DIR}/controllers"

mkdir -p "$CONTROLLER_DIR" "$MODEL_DIR" "$VIEW_DIR" "$WIDGET_DIR" "$TEST_CONTROLLER_DIR"

# ------------------------------------------------------------------------------
# 1. Model Dosyası
# ------------------------------------------------------------------------------
MODEL_FILE="${MODEL_DIR}/${FEATURE_SNAKE}_model.dart"
cat <<EOF > "$MODEL_FILE"
import 'package:flutter/foundation.dart';

@immutable
class ${FEATURE_PASCAL}Model {
  final String id;
  final String title;
  final int value;
  final DateTime timestamp;

  const ${FEATURE_PASCAL}Model({
    required this.id,
    required this.title,
    required this.value,
    required this.timestamp,
  });

  ${FEATURE_PASCAL}Model copyWith({
    String? id,
    String? title,
    int? value,
    DateTime? timestamp,
  }) {
    return ${FEATURE_PASCAL}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory ${FEATURE_PASCAL}Model.fromJson(Map<String, dynamic> json) {
    return ${FEATURE_PASCAL}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: json['value'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'value': value,
        'timestamp': timestamp.toIso8601String(),
      };
}
EOF

# ------------------------------------------------------------------------------
# 2. Controller Dosyası
# ------------------------------------------------------------------------------
CONTROLLER_FILE="${CONTROLLER_DIR}/${FEATURE_SNAKE}_controller.dart"
cat <<EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_SNAKE}_model.dart';

class ${FEATURE_PASCAL}Controller {
  final ValueNotifier<int> totalScore = ValueNotifier<int>(0);
  final ValueNotifier<List<${FEATURE_PASCAL}Model>> items =
      ValueNotifier<List<${FEATURE_PASCAL}Model>>(const []);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void addItem(String title, int value) {
    if (value <= 0 || title.trim().isEmpty) return;
    
    final newItem = ${FEATURE_PASCAL}Model(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      value: value,
      timestamp: DateTime.now(),
    );
    
    totalScore.value += value;
    items.value = [newItem, ...items.value];
  }

  void reset() {
    totalScore.value = 0;
    items.value = const [];
  }

  void dispose() {
    totalScore.dispose();
    items.dispose();
    isLoading.dispose();
  }
}
EOF

# ------------------------------------------------------------------------------
# 3. Widgets Dosyaları
# ------------------------------------------------------------------------------
SUMMARY_CARD_FILE="${WIDGET_DIR}/${FEATURE_SNAKE}_summary_card.dart"
cat <<EOF > "$SUMMARY_CARD_FILE"
import 'package:flutter/material.dart';
import '../controllers/${FEATURE_SNAKE}_controller.dart';

class ${FEATURE_PASCAL}SummaryCard extends StatelessWidget {
  final ${FEATURE_PASCAL}Controller controller;

  const ${FEATURE_PASCAL}SummaryCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ValueListenableBuilder<int>(
          valueListenable: controller.totalScore,
          builder: (context, total, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${FEATURE_PASCAL} Toplam', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  '\$total',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
EOF

ACTIONS_CARD_FILE="${WIDGET_DIR}/${FEATURE_SNAKE}_actions_card.dart"
cat <<EOF > "$ACTIONS_CARD_FILE"
import 'package:flutter/material.dart';
import '../controllers/${FEATURE_SNAKE}_controller.dart';

class ${FEATURE_PASCAL}ActionsCard extends StatelessWidget {
  final ${FEATURE_PASCAL}Controller controller;

  const ${FEATURE_PASCAL}ActionsCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.addItem('Hızlı Kayıt', 100),
            icon: const Icon(Icons.add),
            label: const Text('+100 Ekle'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Sıfırla',
          onPressed: controller.reset,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
EOF

# ------------------------------------------------------------------------------
# 4. View Dosyası (Max 40 satır build kuralı!)
# ------------------------------------------------------------------------------
VIEW_FILE="${VIEW_DIR}/${FEATURE_SNAKE}_view.dart"
cat <<EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controllers/${FEATURE_SNAKE}_controller.dart';
import '../widgets/${FEATURE_SNAKE}_summary_card.dart';
import '../widgets/${FEATURE_SNAKE}_actions_card.dart';

class ${FEATURE_PASCAL}View extends StatelessWidget {
  final ${FEATURE_PASCAL}Controller controller;

  const ${FEATURE_PASCAL}View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${FEATURE_PASCAL} Modülü'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ${FEATURE_PASCAL}SummaryCard(controller: controller),
              const SizedBox(height: 16),
              ${FEATURE_PASCAL}ActionsCard(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

# ------------------------------------------------------------------------------
# 5. Birim Test Dosyası
# ------------------------------------------------------------------------------
TEST_FILE="${TEST_CONTROLLER_DIR}/${FEATURE_SNAKE}_controller_test.dart"
cat <<EOF > "$TEST_FILE"
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/${FEATURE_SNAKE}/controllers/${FEATURE_SNAKE}_controller.dart';

void main() {
  group('${FEATURE_PASCAL}Controller Testleri', () {
    late ${FEATURE_PASCAL}Controller controller;

    setUp(() {
      controller = ${FEATURE_PASCAL}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç değerleri sıfır ve boş liste olmalıdır', () {
      expect(controller.totalScore.value, 0);
      expect(controller.items.value.isEmpty, true);
    });

    test('addItem çağrıldığında totalScore artmalı ve yeni öğe eklenmelidir', () {
      controller.addItem('Test Öğesi', 150);

      expect(controller.totalScore.value, 150);
      expect(controller.items.value.length, 1);
      expect(controller.items.value.first.title, 'Test Öğesi');
      expect(controller.items.value.first.value, 150);
    });

    test('reset çağrıldığında durum sıfırlanmalıdır', () {
      controller.addItem('Öğe 1', 200);
      controller.reset();

      expect(controller.totalScore.value, 0);
      expect(controller.items.value.isEmpty, true);
    });
  });
}
EOF

# İzinleri ayarla
chmod +x "$0" 2>/dev/null || true

echo -e "${GREEN}✔ Başarılı! Feature iskeleti üretildi:${NC}"
echo -e "  - Model:      ${BLUE}${MODEL_FILE}${NC}"
echo -e "  - Controller: ${BLUE}${CONTROLLER_FILE}${NC}"
echo -e "  - View:       ${BLUE}${VIEW_FILE}${NC}"
echo -e "  - Widgets:    ${BLUE}${WIDGET_DIR}/${NC}"
echo -e "  - Test:       ${BLUE}${TEST_FILE}${NC}"
echo ""
echo -e "${YELLOW}Şimdi aşağıdaki doğrulama adımlarını çalıştırabilirsiniz:${NC}"
echo -e "  ${GREEN}flutter analyze${NC}"
echo -e "  ${GREEN}flutter test${NC}"
