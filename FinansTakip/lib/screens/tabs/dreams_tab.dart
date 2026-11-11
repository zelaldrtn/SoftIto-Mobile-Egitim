import 'package:flutter/material.dart';
import '../../models/saving_goal_model.dart';
import '../../providers/finance_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/pinterest_goal_card.dart';
import '../forms/add_goal_sheet.dart';
import '../forms/deposit_goal_dialog.dart';

class DreamsTab extends StatelessWidget {
  final FinanceState state;

  const DreamsTab({super.key, required this.state});

  void _openAddGoal(BuildContext context, {SavingGoalModel? goal}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddGoalSheet(
        initialGoal: goal,
        onSave: (saved) {
          if (goal == null) {
            state.addSavingGoal(saved);
          } else {
            state.updateSavingGoal(saved);
          }
        },
      ),
    );
  }

  void _showDeleteGoalDialog(BuildContext context, SavingGoalModel goal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hedefi Sil'),
        content: Text('"${goal.title}" hedefini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              state.deleteSavingGoal(goal.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hedef silindi.')),
              );
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goals = state.goals;

    double totalTarget = 0;
    double totalSaved = 0;
    for (var g in goals) {
      totalTarget += g.targetAmount;
      totalSaved += g.savedAmount;
    }
    final overallRatio = totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0.0;
    final overallPercent = (overallRatio * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vision Board Başlık Banner'ı (Dreamy Money Aesthetics)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF381F4C),
                    Color(0xFF5B347B),
                    Color(0xFF86529E),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5B347B).withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.dreamyYellow, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'DREAMY VISION BOARD',
                            style: TextStyle(
                              color: AppColors.dreamyYellow,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${goals.length} Aktif Hedef',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Hayallerine Doğru Adım Adım',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Küçük birikimler, büyük hedeflerin anahtarıdır. İstikrarlı ol, hedefine ulaş!',
                    style: TextStyle(
                      color: Color(0xFFE4D5F2),
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Genel İlerleme Çubuğu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Toplam Biriken: ${CurrencyFormatter.format(totalSaved, showDecimals: false)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '%$overallPercent',
                        style: const TextStyle(
                          color: AppColors.dreamyYellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: overallRatio,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.dreamyYellow),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pinterest Panosu Başlık ve Hedef Ekle Butonu (Kartların üstünü kapatmaması için - Item 6)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pinterest Panosu 📌',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openAddGoal(context),
                  icon: const Icon(Icons.add_photo_alternate_rounded, size: 16, color: Colors.white),
                  label: const Text(
                    'Hedef Ekle',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dreamyLilac,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Pinterest Tarzı 2 Sütunlu Masonry Grid (Item 5)
            if (goals.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey.withOpacity(0.4)),
                    const SizedBox(height: 12),
                    const Text('Henüz bir birikim hedefi eklemediniz.'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _openAddGoal(context),
                      child: const Text('İlk Hedefini ve Fotoğrafını Belirle'),
                    ),
                  ],
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sol Sütun (Çift indeksli hedefler)
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < goals.length; i += 2)
                          PinterestGoalCard(
                            goal: goals[i],
                            index: i,
                            onTap: () => _openAddGoal(context, goal: goals[i]),
                            onDepositTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => DepositGoalDialog(
                                  goal: goals[i],
                                  onDeposit: (amt, note) {
                                    state.depositToGoal(goals[i].id, amt, note: note);
                                  },
                                ),
                              );
                            },
                            onDeleteTap: () => _showDeleteGoalDialog(context, goals[i]),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sağ Sütun (Tek indeksli hedefler)
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 1; i < goals.length; i += 2)
                          PinterestGoalCard(
                            goal: goals[i],
                            index: i,
                            onTap: () => _openAddGoal(context, goal: goals[i]),
                            onDepositTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => DepositGoalDialog(
                                  goal: goals[i],
                                  onDeposit: (amt, note) {
                                    state.depositToGoal(goals[i].id, amt, note: note);
                                  },
                                ),
                              );
                            },
                            onDeleteTap: () => _showDeleteGoalDialog(context, goals[i]),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
