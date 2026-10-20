import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/currency_extensions.dart';
import '../models/car_model.dart';
import 'car_spec_chip.dart';

/// Araç listesinde gösterilen vitrin kartı.
class CarCard extends StatelessWidget {
  const CarCard({
    required this.car,
    required this.onTap,
    super.key,
  });

  final Car car;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _CarImageSection(car: car),
            _CarInfoSection(car: car),
          ],
        ),
      ),
    );
  }
}

class _CarImageSection extends StatelessWidget {
  const _CarImageSection({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            car.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(
                child: Icon(Icons.directions_car, size: 54, color: Colors.grey),
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.star_rounded,
                    color: AppColors.primaryYellow, size: 16),
                const SizedBox(width: 4),
                Text(
                  car.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CarInfoSection extends StatelessWidget {
  const _CarInfoSection({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  car.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Text(
                '${car.dailyPrice.toCurrencyString} / gün',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              CarSpecChip(
                icon: Icons.calendar_today_rounded,
                label: '${car.year}',
              ),
              CarSpecChip(
                icon: Icons.local_gas_station_rounded,
                label: car.fuelType.label,
              ),
              CarSpecChip(
                icon: Icons.settings_suggest_rounded,
                label: car.transmission.label,
              ),
              CarSpecChip(
                icon: Icons.airline_seat_recline_normal_rounded,
                label: '${car.seats} Koltuk',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
