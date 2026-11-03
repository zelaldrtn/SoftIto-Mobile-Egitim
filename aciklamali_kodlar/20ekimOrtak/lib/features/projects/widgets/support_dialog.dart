import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';
import '../models/project_model.dart';

// girişim projesine maddi veya fonlama desteği verme diyaloğu
class SupportDialog extends StatefulWidget {
  final ProjectModel project;

  const SupportDialog({super.key, required this.project});

  // diyaloğu dışarıdan tek satırda açabilmek için statik yardımcı metot
  static Future<void> show(BuildContext context, ProjectModel project) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => SupportDialog(project: project),
    );
  }

  @override
  State<SupportDialog> createState() => _SupportDialogState();
}

class _SupportDialogState extends State<SupportDialog> {
  // bağış/destek miktarı seçenekleri
  static const List<double> _amounts = <double>[100.0, 250.0, 500.0, 1000.0, 2500.0];
  // başlangıçta seçili miktar
  double _selectedAmount = 250.0;

  @override
  Widget build(BuildContext context) {
    // AlertDialog kullanıcıdan bir seçim veya onay almak için açılır pencere sunar
    return AlertDialog(
      title: Text('${widget.project.title}\'na Destek Ol'),
      content: _AmountSelector(
        amounts: _amounts,
        selectedAmount: _selectedAmount,
        // miktar seçildiğinde setState ile ekranı yeni seçime göre güncelliyoruz
        onSelected: (double amt) => setState(() => _selectedAmount = amt),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Vazgeç'),
        ),
        ElevatedButton(
          onPressed: _onConfirm,
          child: const Text('Destekle'),
        ),
      ],
    );
  }

  // desteği onaylayıp controller'a aktarıyoruz ve bildirim mesajı gösteriyoruz
  void _onConfirm() {
    ProjectsController.instance.addSupport(
      widget.project.id,
      _selectedAmount,
    );
    Navigator.of(context).pop();
    // ScaffoldMessenger ekranın altında kısa süreli bilgi mesajı (SnackBar) gösterir
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('₺${_selectedAmount.toStringAsFixed(0)} desteğiniz için teşekkürler! 🎉'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// miktar seçeneklerini yan yana saran ve seçtiren alt widget
class _AmountSelector extends StatelessWidget {
  final List<double> amounts;
  final double selectedAmount;
  final ValueChanged<double> onSelected;

  const _AmountSelector({
    required this.amounts,
    required this.selectedAmount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // diyaloğun içeriği kadar yer kaplamasını sağlar, gereksiz uzamaz
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Destek miktarını seçin:'),
        const SizedBox(height: 12),
        // Wrap sığmayan butonları otomatik bir alt satıra kaydırır
        Wrap(
          // butonlar arası yatay boşluk
          spacing: 8,
          // satırlar arası dikey boşluk
          runSpacing: 8,
          children: amounts.map((double amt) {
            final bool isSelected = amt == selectedAmount;
            return ChoiceChip(
              label: Text('₺${amt.toStringAsFixed(0)}'),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) onSelected(amt);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

