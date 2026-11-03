import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_log.dart';

/// Günlük su tüketim geçmişi listesi widget'ı.
// StatelessWidget: geçmiş su tüketim kayıtlarını listeleyen sabit widget
class WaterHistoryList extends StatelessWidget {
  const WaterHistoryList({
    super.key,
    required this.logs,
    required this.onRemoveLog,
  });

  final List<WaterLog> logs;
  // silme ikonuna basıldığında kaydın id'sini üst katmana ileten callback
  final void Function(String id) onRemoveLog;

  @override
  Widget build(BuildContext context) {
    // kayıt yoksa kullanıcıya boş durum (boş ekran) kutucuğunu gösterir
    if (logs.isEmpty) {
      return const _EmptyState();
    }

    // Column: başlık ve geçmiş listesini dikeyde sıralar
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bugünün Kayıtları',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        // SizedBox: başlık ile liste arasına 10 birim boşluk bırakır
        const SizedBox(height: 10),
        // ListView.separated: kayıtlar arasına sabit boşluk ekleyerek listeler
        ListView.separated(
          // shrinkWrap: listenin sadece içeriği kadar dikey yer kaplamasını sağlar
          shrinkWrap: true,
          // NeverScrollableScrollPhysics: ana sayfa kaydırmasıyla çakışmaması için listenin kendi kaydırmasını kapatır
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          // separatorBuilder: her kayıt arasına 8 birim dikey boşluk bırakır
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = logs[index];
            return _HistoryItemTile(
              log: item,
              onDelete: () => onRemoveLog(item.id),
            );
          },
        ),
      ],
    );
  }
}

// kayıt olmadığında ekranda gösterilen bilgilendirme kutusu
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: const Column(
        children: [
          Icon(Icons.water_drop_outlined, color: AppColors.textMuted, size: 36),
          SizedBox(height: 8),
          Text(
            'Henüz su kaydı bulunmuyor',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// tek bir su tüketim satırının görsel kartı
class _HistoryItemTile extends StatelessWidget {
  const _HistoryItemTile({
    required this.log,
    required this.onDelete,
  });

  final WaterLog log;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    // padLeft(2, '0'): saat ve dakikayı tek haneli ise başına 0 ekleyerek biçimlendirir (örn: 9:5 -> 09:05)
    final timeStr =
        '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.obsidianCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.obsidianBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.neonCyan.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop_rounded,
                color: AppColors.neonCyan, size: 18),
          ),
          const SizedBox(width: 12),
          // Expanded: metin alanının satırdaki kalan tüm boşluğu kaplamasını sağlar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+${log.amountMl} ml (${log.label})',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  timeStr,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // IconButton: kaydı silmeye yarayan çöp/kapatma butonu
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textMuted, size: 18),
            onPressed: onDelete,
            tooltip: 'Kaydı Sil',
          ),
        ],
      ),
    );
  }
}

