import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/currency_extensions.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../../reservations/views/create_reservation_view.dart';
import '../models/car_model.dart';
import '../widgets/car_spec_chip.dart';
import 'add_edit_car_view.dart';

/// Araç Detay Ekranı.
/// Aracın tüm teknik özelliklerini, günlük kiralama ücretini, araç sahibi bilgilerini
/// ve kiralama/düzenleme aksiyonlarını görüntüler.
class CarDetailView extends StatelessWidget {
  const CarDetailView({required this.car, super.key});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _DetailSliverAppBar(car: car),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _TitleAndPriceRow(car: car),
                    const SizedBox(height: 16),
                    _SpecsSection(car: car),
                    const SizedBox(height: 20),
                    _DescriptionSection(car: car),
                    const SizedBox(height: 20),
                    _OwnerCard(car: car),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: _BottomRentBar(car: car),
      ),
    );
  }
}

/// Araç görselini ve geri butonunu içeren esnek SliverAppBar.
class _DetailSliverAppBar extends StatelessWidget {
  const _DetailSliverAppBar({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      leading: const BackButton(),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          car.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(child: Icon(Icons.directions_car, size: 64)),
          ),
        ),
      ),
    );
  }
}

/// Araç tam adı, puanı, yorum sayısı ve kategori bilgisini gösteren başlık satırı.
class _TitleAndPriceRow extends StatelessWidget {
  const _TitleAndPriceRow({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                car.fullName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryYellow.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.star_rounded,
                      color: AppColors.primaryYellow, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${car.rating} (${car.reviewCount})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Kategori: ${car.category.label}',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
      ],
    );
  }
}

/// Yıl, yakıt, vites, koltuk sayısı ve ehliyet gereksinimi çipleri.
class _SpecsSection extends StatelessWidget {
  const _SpecsSection({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 12,
          runSpacing: 10,
          children: <Widget>[
            CarSpecChip(
              icon: Icons.calendar_month_rounded,
              label: '${car.year} Model',
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
              label: '${car.seats} Kişilik',
            ),
            CarSpecChip(
              icon: Icons.badge_rounded,
              label: 'En az ${car.minLicenseYears} Yıllık ${car.licenseClassRequired} Ehliyet',
            ),
          ],
        ),
      ),
    );
  }
}

/// Araç sahibinin girdiği açıklama metni.
class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Araç Açıklaması',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          car.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}

/// Araç sahibi kartı; araç kullanıcıya aitse '(Siz)' ifadesi eklenir.
class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    final UserProfile? user = AuthController.instance.currentUser;
    final bool isMyCar = user != null &&
        (car.ownerId == user.id ||
            (user.role.isOwner &&
                (car.ownerId == 'user_1' || car.ownerId == user.id)));

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.person),
        ),
        title: Text(
          isMyCar ? '${car.ownerName} (Siz)' : car.ownerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          isMyCar ? 'İlan Sahibi (Kendi İlanınız)' : 'Doğrulanmış Araç Sahibi',
        ),
        trailing: Icon(
          isMyCar ? Icons.verified_user_rounded : Icons.verified,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}

/// Ekranın altındaki sabit işlem çubuğu.
/// Araç kullanıcının kendi ilanına aitse 'İlanı Düzenle' butonu gösterilir (kendi aracını kiralama engellenir).
/// Başka bir kullanıcı inceliyorsa 'Hemen Kirala' butonu gösterilir.
class _BottomRentBar extends StatelessWidget {
  const _BottomRentBar({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        final bool isMyCar = user != null &&
            (car.ownerId == user.id ||
                (user.role.isOwner &&
                    (car.ownerId == 'user_1' || car.ownerId == user.id)));

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isMyCar ? 'Kendi İlanınız' : 'Günlük',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isMyCar ? FontWeight.bold : FontWeight.normal,
                        color: isMyCar ? AppColors.primaryGreen : Colors.grey,
                      ),
                    ),
                    Text(
                      car.dailyPrice.toCurrencyString,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: isMyCar
                      ? ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => AddEditCarView(car: car),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: const Text('İlanı Düzenle'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => CreateReservationView(car: car),
                              ),
                            );
                          },
                          child: const Text('Hemen Kirala'),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
