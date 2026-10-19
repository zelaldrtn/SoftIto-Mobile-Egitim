import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';

class CustomBeverageSheet extends StatefulWidget {
  final WaterTrackerController controller;

  const CustomBeverageSheet({super.key, required this.controller});

  @override
  State<CustomBeverageSheet> createState() => _CustomBeverageSheetState();
}

class _CustomBeverageSheetState extends State<CustomBeverageSheet> {
  final TextEditingController _amountController =
      TextEditingController(text: '300');
  final TextEditingController _nameController =
      TextEditingController(text: 'Bitki Çayı');

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = int.tryParse(_amountController.text) ?? 0;
    if (amount > 0) {
      widget.controller.addCustomBeverage(_nameController.text, amount);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Özel İçecek Ekle (Örn: 300ml)',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'İçecek Adı',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Miktar (ml)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: const Text('Tüketime Ekle'),
          ),
        ],
      ),
    );
  }
}
