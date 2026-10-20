import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/currency_extensions.dart';
import '../controllers/car_controller.dart';

/// Fiyat ve detaylı filtreleme alt sayfası (BottomSheet).
class CarFilterSheet extends StatelessWidget {
  const CarFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const CarFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _FilterHeader(),
          const SizedBox(height: 20),
          const _PriceRangeSlider(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sonuçları Göster'),
          ),
        ],
      ),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  const _FilterHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Filtreleri Özelleştir',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            CarController.instance.maxPriceNotifier.value = 10000.0;
            CarController.instance.searchQueryNotifier.value = '';
          },
          child: const Text('Sıfırla'),
        ),
      ],
    );
  }
}

class _PriceRangeSlider extends StatelessWidget {
  const _PriceRangeSlider();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: CarController.instance.maxPriceNotifier,
      builder: (BuildContext context, double maxVal, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Maksimum Günlük Ücret',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  maxVal.toCurrencyString,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryYellow,
                  ),
                ),
              ],
            ),
            Slider(
              value: maxVal,
              min: 1000.0,
              max: 10000.0,
              divisions: 18,
              label: maxVal.toCurrencyString,
              onChanged: (double val) {
                CarController.instance.maxPriceNotifier.value = val;
              },
            ),
          ],
        );
      },
    );
  }
}
