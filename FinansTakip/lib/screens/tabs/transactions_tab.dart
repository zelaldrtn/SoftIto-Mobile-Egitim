import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../providers/finance_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/transaction_item.dart';
import '../forms/add_transaction_sheet.dart';

class TransactionsTab extends StatefulWidget {
  final FinanceState state;

  const TransactionsTab({super.key, required this.state});

  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  String _searchQuery = '';
  TransactionType? _selectedTypeFilter; // null = Hepsi
  String? _needWantFilter; // null = Hepsi, 'need' = İhtiyaç, 'want' = İstek
  String _sortBy = 'date_desc'; // 'date_desc', 'date_asc', 'amount_desc', 'amount_asc'

  void _showDeleteDialog(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('İşlemi Sil'),
        content: Text('"$title" işlemini silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.state.deleteTransaction(id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('İşlem silindi.')),
              );
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openAddSheet(BuildContext context, {TransactionModel? tx}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddTransactionSheet(
        initialTransaction: tx,
        onSave: (savedTx) {
          if (tx == null) {
            widget.state.addTransaction(savedTx);
          } else {
            widget.state.updateTransaction(savedTx);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filtreleme
    List<TransactionModel> filtered = widget.state.transactions.where((t) {
      // Arama filtresi
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = t.title.toLowerCase().contains(q);
        final matchCat = t.category.toLowerCase().contains(q);
        final matchNote = (t.note ?? '').toLowerCase().contains(q);
        if (!matchTitle && !matchCat && !matchNote) return false;
      }

      // Tür filtresi
      if (_selectedTypeFilter != null && t.type != _selectedTypeFilter) {
        return false;
      }

      // İhtiyaç / İstek filtresi (Yalnızca giderler için)
      if (_needWantFilter != null && t.type == TransactionType.expense) {
        if (_needWantFilter == 'need' && !t.isNeed) return false;
        if (_needWantFilter == 'want' && t.isNeed) return false;
      }

      return true;
    }).toList();

    // Sıralama
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'date_asc':
          return a.date.compareTo(b.date);
        case 'amount_desc':
          return b.amount.compareTo(a.amount);
        case 'amount_asc':
          return a.amount.compareTo(b.amount);
        case 'date_desc':
        default:
          return b.date.compareTo(a.date);
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Arama ve Filtre Kontrolleri
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: Column(
              children: [
                // Arama Kutusu
                TextField(
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'İşlem ara (market, maaş, kira...)',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),

                // Tür Filtreleri (Hepsi, Gelir, Gider, Birikim)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Hepsi', _selectedTypeFilter == null, () {
                        setState(() => _selectedTypeFilter = null);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Giderler', _selectedTypeFilter == TransactionType.expense, () {
                        setState(() => _selectedTypeFilter = TransactionType.expense);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Gelirler', _selectedTypeFilter == TransactionType.income, () {
                        setState(() => _selectedTypeFilter = TransactionType.income);
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Birikimler', _selectedTypeFilter == TransactionType.saving, () {
                        setState(() => _selectedTypeFilter = TransactionType.saving);
                      }),
                      const SizedBox(width: 12),
                      // Sıralama Menüsü
                      PopupMenuButton<String>(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardAlt : AppColors.creamCardAlt,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.sort_rounded, size: 18),
                        ),
                        onSelected: (val) {
                          setState(() {
                            _sortBy = val;
                          });
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'date_desc', child: Text('En Yeni Tarih')),
                          const PopupMenuItem(value: 'date_asc', child: Text('En Eski Tarih')),
                          const PopupMenuItem(value: 'amount_desc', child: Text('En Yüksek Tutar')),
                          const PopupMenuItem(value: 'amount_asc', child: Text('En Düşük Tutar')),
                        ],
                      ),
                    ],
                  ),
                ),

                // İhtiyaç vs İstek Ek Filtresi (Gider seçildiğinde)
                if (_selectedTypeFilter == TransactionType.expense || _selectedTypeFilter == null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Tür:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildSubFilterChip('Tümü', _needWantFilter == null, () {
                        setState(() => _needWantFilter = null);
                      }),
                      const SizedBox(width: 6),
                      _buildSubFilterChip('İhtiyaç', _needWantFilter == 'need', () {
                        setState(() => _needWantFilter = 'need');
                      }),
                      const SizedBox(width: 6),
                      _buildSubFilterChip('İstek', _needWantFilter == 'want', () {
                        setState(() => _needWantFilter = 'want');
                      }),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Liste Görünümü
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 54,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Kayıtlı işlem bulunamadı',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Aşağıdaki butona basarak yeni bir işlem ekleyebilirsiniz.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 90),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final tx = filtered[index];
                      return TransactionItem(
                        transaction: tx,
                        onTap: () => _openAddSheet(context, tx: tx),
                        onDelete: () => _showDeleteDialog(context, tx.id, tx.title),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton.extended(
          onPressed: () => _openAddSheet(context),
          backgroundColor: AppColors.forestPrimary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'İşlem Ekle',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.forestPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.forestPrimary : AppColors.warmBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSubFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dreamyYellow : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF6B4E00) : Colors.grey,
          ),
        ),
      ),
    );
  }
}
