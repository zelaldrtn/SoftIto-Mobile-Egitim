import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/exchange_rate_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../theme/app_theme.dart';
import '../../../providers/finance_state.dart';

class SettingsScreen extends StatefulWidget {
  final FinanceState state;

  const SettingsScreen({super.key, required this.state});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = widget.state.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Görünüm & Tema
          const Text('Görünüm', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
              ),
            ),
            child: SwitchListTile(
              title: const Text('Koyu Tema (Editorial Dark)'),
              subtitle: Text(isDark ? 'Zümrüt yeşili koyu mod aktif' : 'Sıcak krem açık mod aktif'),
              secondary: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? AppColors.dreamyYellow : AppColors.forestPrimary,
              ),
              value: isDark,
              activeColor: AppColors.forestMint,
              onChanged: (_) => widget.state.toggleTheme(),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Ana Para Birimi & Döviz
          const Text('Para Birimi & Kurlar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Varsayılan Ana Para Birimi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Dashboard ve tüm özetler bu para birimine dönüştürülerek gösterilir.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: AppConstants.supportedCurrencies.map((cur) {
                    final isSelected = widget.state.primaryCurrency == cur;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Center(
                            child: Text(
                              '$cur (${AppConstants.currencySymbol(cur)})',
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) widget.state.setPrimaryCurrency(cur);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                const Text('Güncel Döviz Kurları (TRY Bazlı):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  '${ExchangeRateService.instance.formatRateInfo(from: 'USD', to: 'TRY')}   •   ${ExchangeRateService.instance.formatRateInfo(from: 'EUR', to: 'TRY')}',
                  style: const TextStyle(fontSize: 12, color: AppColors.forestPrimary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Bildirim Tercihleri
          const Text('Bildirimler', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.warmBorder,
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Bütçe Uyarıları'),
                  subtitle: const Text('Bütçe %80 ve %100 aşımında bildir'),
                  value: NotificationService.instance.notifyBudgetEnabled,
                  activeColor: AppColors.forestPrimary,
                  onChanged: (val) {
                    setState(() {
                      widget.state.setNotificationPreference(budget: val);
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Düzenli Ödeme Hatırlatıcıları'),
                  subtitle: const Text('Ödeme gününden 1 gün önce hatırlat'),
                  value: NotificationService.instance.notifyRecurringEnabled,
                  activeColor: AppColors.forestPrimary,
                  onChanged: (val) {
                    setState(() {
                      widget.state.setNotificationPreference(recurring: val);
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Birikim Hedefi Bildirimleri'),
                  subtitle: const Text('Hedefe ulaşıldığında tebrik bildirimi'),
                  value: NotificationService.instance.notifySavingsEnabled,
                  activeColor: AppColors.forestPrimary,
                  onChanged: (val) {
                    setState(() {
                      widget.state.setNotificationPreference(savings: val);
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Uygulama Hakkında
          Center(
            child: Column(
              children: [
                const Text(
                  AppConstants.appName,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sürüm 1.0.0 • Material 3 & Supabase',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

