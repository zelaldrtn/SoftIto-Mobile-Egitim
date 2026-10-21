import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class UsableMoneyCard extends StatefulWidget {
  final double usableMoney;
  final double currentBalance;
  final double upcomingRecurring;
  final double reservedSavings;
  final double protectedBuffer;
  final double dailyRecommended;
  final double weeklyRecommended;

  const UsableMoneyCard({
    super.key,
    required this.usableMoney,
    required this.currentBalance,
    required this.upcomingRecurring,
    required this.reservedSavings,
    required this.protectedBuffer,
    required this.dailyRecommended,
    required this.weeklyRecommended,
  });

  @override
  State<UsableMoneyCard> createState() => _UsableMoneyCardState();
}

class _UsableMoneyCardState extends State<UsableMoneyCard> {
  bool _showFormulaDetail = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.forestDeep,
            AppColors.forestPrimary,
            AppColors.forestMedium,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestDeep.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst Satır: Başlık & Bilgi Butonu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.dreamyYellow,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Kullanılabilir Para',
                    style: TextStyle(
                      color: Color(0xFFE2EFE7),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _showFormulaDetail = !_showFormulaDetail;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _showFormulaDetail ? 'Gizle' : 'Formül',
                        style: const TextStyle(
                          color: AppColors.dreamyYellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _showFormulaDetail
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.dreamyYellow,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tutar (Büyük Tipografi)
          Text(
            CurrencyFormatter.format(widget.usableMoney),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 14),

          // Önerilen Günlük / Haftalık Harcama Rozeti
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.dreamyYellow,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Önerilen Günlük Bütçe',
                          style: TextStyle(
                            color: Color(0xFFC7DECE),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(widget.dailyRecommended, showDecimals: false),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Haftalık Limit',
                      style: TextStyle(
                        color: Color(0xFFC7DECE),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(widget.weeklyRecommended, showDecimals: false),
                      style: const TextStyle(
                        color: AppColors.dreamyYellow,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Açılır Formül Detayı
          if (_showFormulaDetail) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Akıllı Bütçe Hesaplama Detayı:',
                    style: TextStyle(
                      color: AppColors.dreamyYellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFormulaRow(
                    'Mevcut Net Bakiye',
                    '+ ${CurrencyFormatter.format(widget.currentBalance)}',
                    Colors.white,
                  ),
                  _buildFormulaRow(
                    'Yaklaşan Zorunlu Ödemeler',
                    '- ${CurrencyFormatter.format(widget.upcomingRecurring)}',
                    AppColors.dreamyLilacLight,
                  ),
                  _buildFormulaRow(
                    'Ayrılmış Birikimler',
                    '- ${CurrencyFormatter.format(widget.reservedSavings)}',
                    AppColors.dreamyLilacLight,
                  ),
                  _buildFormulaRow(
                    'Korunacak Güvence Payı (%10)',
                    '- ${CurrencyFormatter.format(widget.protectedBuffer)}',
                    AppColors.dreamyLilacLight,
                  ),
                  const Divider(color: Colors.white24, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kullanılabilir Net:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(widget.usableMoney),
                        style: const TextStyle(
                          color: AppColors.dreamyYellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormulaRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFFC7DECE), fontSize: 12),
          ),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
