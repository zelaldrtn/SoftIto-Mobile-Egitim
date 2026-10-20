import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/currency_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../controllers/reservation_controller.dart';
import '../models/reservation_model.dart';

/// Rezervasyon kart bileşeni.
class ReservationCard extends StatelessWidget {
  const ReservationCard({
    required this.reservation,
    required this.isOwnerView,
    super.key,
  });

  final Reservation reservation;
  final bool isOwnerView;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _HeaderRow(reservation: reservation),
            const Divider(height: 20),
            _DetailsRow(reservation: reservation),
            if (isOwnerView) ...<Widget>[
              const SizedBox(height: 8),
              _RenterInfo(reservation: reservation),
            ],
            const SizedBox(height: 12),
            _ActionButtons(
              reservation: reservation,
              isOwnerView: isOwnerView,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.reservation});

  final Reservation reservation;

  Color _getStatusColor() {
    switch (reservation.status) {
      case ReservationStatus.onaylandi:
        return AppColors.primaryGreen;
      case ReservationStatus.reddedildi:
      case ReservationStatus.iptalEdildi:
        return AppColors.errorRed;
      case ReservationStatus.tamamlandi:
        return AppColors.primaryBlue;
      case ReservationStatus.beklemede:
        return AppColors.primaryYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            reservation.carImageUrl,
            width: 50,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Icon(Icons.directions_car),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                reservation.carFullName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '${reservation.totalPrice.toCurrencyString} (${reservation.totalDays} gün)',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor().withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            reservation.status.label,
            style: TextStyle(
              color: _getStatusColor(),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(Icons.date_range_rounded, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              '${reservation.startDate.toFormattedString} - ${reservation.endDate.toFormattedString}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          'Ehliyet: ${reservation.licenseClass} (${reservation.licenseYear})',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _RenterInfo extends StatelessWidget {
  const _RenterInfo({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.person_pin_rounded, size: 18),
          const SizedBox(width: 8),
          Text(
            'Talep Eden: ${reservation.renterName} (${reservation.renterPhone})',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.reservation,
    required this.isOwnerView,
  });

  final Reservation reservation;
  final bool isOwnerView;

  void _confirmAction(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!reservation.status.isPending) {
      return const SizedBox.shrink();
    }

    if (isOwnerView) {
      return Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: () => _confirmAction(
                context,
                title: 'Talebi Reddet',
                content: 'Bu rezervasyon talebini reddetmek istediğinize emin misiniz?',
                onConfirm: () => ReservationController.instance.updateStatus(
                  reservation.id,
                  ReservationStatus.reddedildi,
                ),
              ),
              child: const Text('Reddet'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _confirmAction(
                context,
                title: 'Talebi Kabul Et',
                content: 'Bu rezervasyon talebini onaylamak istediğinize emin misiniz?',
                onConfirm: () {
                  final bool success =
                      ReservationController.instance.approveReservation(
                    reservation.id,
                    onError: (String reason) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(reason),
                          backgroundColor: AppColors.errorRed,
                        ),
                      );
                    },
                  );
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rezervasyon talebi onaylandı.'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    );
                  }
                },
              ),
              child: const Text('Onayla'),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _confirmAction(
          context,
          title: 'Rezervasyonu İptal Et',
          content: 'Rezervasyon talebinizi iptal etmek istediğinize emin misiniz?',
          onConfirm: () =>
              ReservationController.instance.cancelReservation(reservation.id),
        ),
        child: const Text('Talebi İptal Et'),
      ),
    );
  }
}
